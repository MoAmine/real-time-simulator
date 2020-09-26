with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;
with Text_IO;               use Text_IO;
with user_level_schedulers; use user_level_schedulers;
with user_level_tasks;      use user_level_tasks;

with my_subprograms; use my_subprograms;

procedure example is
begin
   -- Creation des taches
   --procedure new_user_level_task
    --    (id         : in out Integer;
      --   period     : in Integer;
        -- capacity   : in Integer;
        -- arriving   : in Integer;
         --deadline   : in Integer;
         --the_type   : in task_type;
         --subprogram : in run_subprogram)
   user_level_scheduler.new_user_level_task (id1, 5, 4, 2, 5, periodic, T1'Access);
   user_level_scheduler.new_user_level_task (id2, 4, 3, 1, 4, sporadic, T2'Access);
   user_level_scheduler.new_user_level_task (id3, 0, 8, 2, 15, aperiodic, T3'Access);

   -- ordonnancement selon edf
   edf_schedule (28);
   abort_tasks;

end example;