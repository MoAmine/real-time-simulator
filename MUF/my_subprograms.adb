with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;
with Text_IO;               use Text_IO;
with user_level_schedulers; use user_level_schedulers;
with user_level_tasks;      use user_level_tasks;

package body my_subprograms is

   procedure T1 is
   begin
      Put_Line
        ("Task" &
         Integer'Image (id1) &
         " is running at time " &
         Integer'Image (user_level_scheduler.get_current_time));
   end T1;

   procedure T2 is
   begin
      Put_Line
        ("Task" &
         Integer'Image (id2) &
         " is running at time " &
         Integer'Image (user_level_scheduler.get_current_time));
   end T2;

   procedure T3 is
   begin
      Put_Line
        ("Task" &
         Integer'Image (id3) &
         " is running at time " &
         Integer'Image (user_level_scheduler.get_current_time));
   end T3;

   procedure T4 is
   begin
      Put_Line
        ("Task" &
         Integer'Image (id4) &
         " is running at time " &
         Integer'Image (user_level_scheduler.get_current_time));
   end T4;

end my_subprograms;