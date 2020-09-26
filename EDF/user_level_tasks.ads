with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;

package user_level_tasks is

   -- Prototype of the subprograms
   -- that are run by any user level tasks
   --
   type run_subprogram is access procedure;

   -- Tasks handled by user level schedulers
   --
   task type user_level_task
        (id                : Integer;
         subprogram_to_run : run_subprogram)
      is
      entry wait_for_processor;
      entry release_processor;
   end user_level_task;
   type user_level_task_ptr is access user_level_task;

end user_level_tasks;