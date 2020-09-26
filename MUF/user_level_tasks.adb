with user_level_schedulers; use user_level_schedulers;
with Text_IO;               use Text_IO;

package body user_level_tasks is

   task body user_level_task is
      my_tcb            : tcb;
      executed_capacity : Integer;
   begin
      my_tcb            := user_level_scheduler.get_tcb (id);
      executed_capacity := my_tcb.capacity;
      
      loop
         accept wait_for_processor;
         subprogram_to_run.all;
         executed_capacity := executed_capacity - 1;
         if (executed_capacity = 0) then
            user_level_scheduler.set_task_status (id, task_pended);
            executed_capacity := my_tcb.capacity;
         end if;
         accept release_processor;
      end loop;
   end user_level_task;

end user_level_tasks;
