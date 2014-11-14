Makefiles
It can be cumbersome to type all of the gcc lines over and over again, especially if you are making a lot of changes to the code and it has several libraries. The make facility solves this problem. You can use the following makefile to replace the compilation sequence above:
main: main.o util.o
        gcc -o main main.o util.o
main.o: main.c util.h
        gcc -c -g main.c
util.o: util.c util.h
        gcc -c -g util.c
Enter this into a file named makefile, and type maketo build the executable. Note that you must precede all gcc lines with a tab. (Eight spaces will not suffice -- it must be a tab. All other lines must be flush left.)
This makefile contains two types of lines. The lines appearing flush left are dependency lines. The lines preceded by a tab are executable lines, which can contain any valid UNIX command. A dependency line says that some file is dependent on some other set of files. For example, main.o: main.c util.h says that the file main.o is dependent on the files main.c and util.h. If either of these two files changes, the following executable line(s) should be executed to recreate main.o.
Note that the final executable produced by the whole makefile is main, on line 1 in the makefile. The final result of the makefile should always go on line 1, which in this makefile says that the file main is dependent on main.o and util.o. If either of these changes, execute the line gcc -o main main.o util.o to recreate main.
It is possible to put multiple lines to be executed below a dependency line -- they must all start with a tab. A large program may have several libraries and a main program. The makefile automatically recompiles everything that needs to be recompiled because of a change.
If you are not working on a UNIX machine, your compiler almost certainly has functionality equivalent to makefiles. Read the documentation for your compiler to learn how to use it.
Now you understand why you have been including stdio.h in earlier programs. It is simply a standard library that someone created long ago and made available to other programmers to make their lives easier.