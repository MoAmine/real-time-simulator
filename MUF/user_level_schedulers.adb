with Text_IO; use Text_IO;

package body user_level_schedulers is

   

   procedure muf (duration_in_time_unit : Integer) is
      a_tcb1          : tcb;
      a_tcb2          : tcb;
      no_ready_task   : Boolean;
      elected_task    : tcb;
      minimum_laxity : Integer;
      user_pr :       Integer;
      utilization       : Integer; 
      current_time      : Integer;
   begin

      -- sorting
          for i in 1 .. user_level_scheduler.get_number_of_task loop
            for j in 1 .. user_level_scheduler.get_number_of_task loop
            a_tcb1 := user_level_scheduler.get_tcb (i);
            a_tcb2 := user_level_scheduler.get_tcb (j);
               if (a_tcb1.period < a_tcb2.period) then
                    user_level_scheduler.set_tcbs (i, a_tcb2);
                    user_level_scheduler.set_tcbs (j, a_tcb1);
               end if;
            end loop;
         end loop;

       utilization := 0;

      --Set critical value
       for i in 1 .. user_level_scheduler.get_number_of_task loop
            a_tcb1 := user_level_scheduler.get_tcb(i);
            a_tcb1.user_priority := i;
            
            utilization := utilization + a_tcb1.utilization;
              if utilization <= 100 then
                   user_level_scheduler.set_task_critical (i, HIGH);
               else
                    user_level_scheduler.set_task_critical (i, LOW);   
               end if;
      end loop;

      
      
      loop
        -- Find the next task to run

         no_ready_task   := True;
         minimum_laxity := Integer'Last;
         user_pr := 0;

   
      --selection la tache HIGH to run
      for i in 1 .. user_level_scheduler.get_number_of_task loop

            a_tcb1 := user_level_scheduler.get_tcb (i);
            current_time := user_level_scheduler.get_current_time;
            a_tcb1.laxity := a_tcb1.deadline - current_time - a_tcb1.capacity;

            if a_tcb1.status = task_ready and a_tcb1.critical = HIGH then
                  no_ready_task := False;
                     if a_tcb1.laxity < minimum_laxity then
                     minimum_laxity := a_tcb1.laxity;
                     user_pr        := a_tcb1.user_priority;
                     elected_task   := a_tcb1;
                     end if;
                     if a_tcb1.laxity = minimum_laxity then
                        if a_tcb1.user_priority > user_pr then
                        minimum_laxity := a_tcb1.laxity;
                        user_pr        := a_tcb1.user_priority;
                        elected_task    := a_tcb1;
                        end if;
                     end if;
                end if; 
      end loop;
                    


   -- Si il y a pas de task HIGH ready selectionner la tache low to run
      if no_ready_task then
          for i in 1 .. user_level_scheduler.get_number_of_task loop

            a_tcb1 := user_level_scheduler.get_tcb (i);
            current_time := user_level_scheduler.get_current_time;
            a_tcb1.laxity := a_tcb1.deadline - current_time - a_tcb1.capacity;

            if a_tcb1.status = task_ready and a_tcb1.critical = LOW then
                  no_ready_task := False;
                     if a_tcb1.laxity < minimum_laxity then
                     minimum_laxity := a_tcb1.laxity;
                     user_pr        := a_tcb1.user_priority;
                     elected_task   := a_tcb1;
                     end if;
                     if a_tcb1.laxity = minimum_laxity then
                        if a_tcb1.user_priority < user_pr then
                        minimum_laxity := a_tcb1.laxity;
                        user_pr        := a_tcb1.user_priority;
                        elected_task    := a_tcb1;
                        end if;
                     end if;
                end if; 
      end loop;
      end if;
         -- Run the task
         --
         if not no_ready_task then
            elected_task.the_task.wait_for_processor;
            elected_task.the_task.release_processor;
         else
            Put_Line
              ("No task to run at time " &
               Integer'Image (user_level_scheduler.get_current_time));
         end if;

         -- Go to the next unit of time
         --
         user_level_scheduler.next_time;
         exit when user_level_scheduler.get_current_time >
                   duration_in_time_unit;

         -- release periodic tasks
         --
         for i in 1 .. user_level_scheduler.get_number_of_task loop
            a_tcb1 := user_level_scheduler.get_tcb(i);
            if (a_tcb1.status = task_pended ) then
               if user_level_scheduler.get_current_time mod a_tcb1.period =
                  0
               then
               user_level_scheduler.set_task_deadline (i, a_tcb1.deadline + a_tcb1.period);

                  Put_Line("--------------------------------------");
                  Put_Line
                    ("Task" &
                     Integer'Image (i) &
                     " is released at time " &
                     Integer'Image (user_level_scheduler.get_current_time) & 
                     " deadline of " &
                     Integer'Image (user_level_scheduler.get_tcb(i).deadline)
                     );
                  Put_Line("--------------------------------------");
                  user_level_scheduler.set_task_status (i, task_ready);

               end if;
            end if;
         end loop;

      end loop;
   end muf;





   procedure abort_tasks is
      a_tcb : tcb;
   begin
      if (user_level_scheduler.get_number_of_task = 0) then
         raise Constraint_Error;
      end if;

      for i in 1 .. user_level_scheduler.get_number_of_task loop
         a_tcb := user_level_scheduler.get_tcb (i);
         abort a_tcb.the_task.all;
      end loop;
   end abort_tasks;

   protected body user_level_scheduler is

      procedure set_task_status (id : Integer; s : task_status) is
      begin
         tcbs (id).status := s;
      end set_task_status;
      procedure set_task_deadline (id : Integer; d : Integer) is
      begin
         tcbs (id).deadline := d;
      end set_task_deadline;

      procedure set_task_critical (id : Integer; c : task_critical) is
      begin
         tcbs (id).critical := c;
      end set_task_critical;
      
      procedure set_tcbs (id : Integer; a_tcb : tcb) is
      begin
         tcbs (id) := a_tcb;
      end set_tcbs;

      function get_tcb (id : Integer) return tcb is
      begin
         return tcbs (id);
      end get_tcb;

      procedure new_user_level_task
        (id         : in out Integer;
         period     : in Integer;
         capacity   : in Integer;
         utilization : in Integer;
         subprogram : in run_subprogram)
      is
         a_tcb : tcb;
      begin
         if (number_of_task + 1 > max_user_level_task) then
            raise Constraint_Error;
         end if;

         number_of_task        := number_of_task + 1;
         a_tcb.period          := period;
         a_tcb.capacity        := capacity;
         a_tcb.utilization     := utilization;
         a_tcb.critical        := HIGH;
         a_tcb.deadline        := period;
         a_tcb.user_priority   := max_user_level_task - number_of_task;
         a_tcb.status          := task_ready; 
         a_tcb.the_task        :=
           new user_level_task (number_of_task, subprogram);
         tcbs (number_of_task) := a_tcb;
         id                    := number_of_task;
      end new_user_level_task;

      function get_number_of_task return Integer is
      begin
         return number_of_task;
      end get_number_of_task;

      function get_current_time return Integer is
      begin
         return current_time;
      end get_current_time;

      procedure next_time is
      begin
         current_time := current_time + 1;
      end next_time;

   end user_level_scheduler;

end user_level_schedulers;