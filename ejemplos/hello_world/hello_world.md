The hello world program

To illustrate the large purpose of VHDL, here is a commented VHDL "Hello world" program.

     --  Hello world program.
     use std.textio.all; --  Imports the standard textio package.
     
     --  Defines a design entity, without any ports.
     entity hello_world is
     end hello_world;
     
     architecture behaviour of hello_world is
     begin
        process
           variable l : line;
        begin
           write (l, String'("Hello world!"));
           writeline (output, l);
           wait;
        end process;
     end behaviour;

Suppose this program is contained in the file hello.vhdl. First, you have to compile the file; this is called analysis of a design file in VHDL terms.

     $ ghdl -a hello.vhdl

This command creates or updates a file work-obj93.cf, which describes the library ‘work’. On GNU/Linux, this command generates a file hello.o, which is the object file corresponding to your VHDL program. The object file is not created on Windows.

Then, you have to build an executable file.

     $ ghdl -e hello_world

The ‘-e’ option means elaborate. With this option, GHDL creates code in order to elaborate a design, with the ‘hello’ entity at the top of the hierarchy.

On GNU/Linux, the result is an executable program called hello which can be run:

     $ ghdl -r hello_world

or directly:

     $ ./hello_world

On Windows, no file is created. The simulation is launched using this command:

     > ghdl -r hello_world

The result of the simulation appears on the screen:

     Hello world!
