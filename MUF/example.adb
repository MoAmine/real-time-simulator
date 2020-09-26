with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;
with Text_IO;               use Text_IO;
with user_level_schedulers; use user_level_schedulers;
with user_level_tasks;      use user_level_tasks;

with my_subprograms; use my_subprograms;

procedure example is

begin
   -- Creation des taches
  -- procedure new_user_level_task
   --     (id         : in out Integer;
    --     period     : in Integer;
    --     capacity   : in Integer;
    --     utilization : in Integer;
    --     subprogram : in run_subprogram)
    
   user_level_scheduler.new_user_level_task (id1, 6, 2, 33, T1'Access);
   user_level_scheduler.new_user_level_task (id2, 10, 4, 40, T2'Access);
   user_level_scheduler.new_user_level_task (id3, 12, 3, 25, T3'Access);
   user_level_scheduler.new_user_level_task (id4, 15, 4, 27, T4'Access);

   -- ordonnancement selon MUF
   muf (24);
   abort_tasks;

end example;