##Introduction to the Basics of C Programming

The C programming language is a popular and widely used programming language for creating **computer programs**. Programmers around the world embrace C because it gives maximum control and efficiency to the programmer.

```
C语言是一种流行和广泛使用的编程语言，用于创建计算机程序。世界各地的程序员拥抱C，因为它提供了最大的控制和效率的程序员。
```
If you are a programmer, or if you are interested in becoming a programmer, there are a couple of benefits you gain from learning C:

* You will be able to read and write code for a large number of platforms -- everything from microcontrollers to the most advanced scientific systems can be written in C, and many modern operating systems are written in C.
* The jump to the object oriented C++ language becomes much easier. C++ is an extension of C, and it is nearly impossible to learn C++ without learning C first.

```
如果你是一个程序员，或者如果你有兴趣成为一名程序员，也有你学习C获得了几个好处：

-> 您将能够阅读和编写代码进行了大量的平台 - 从微控制器的一切，以最先进的科学系统，可以用C写的，许多现代操作系统都写在C.

-> 跳转到面向对象的C ++语言变得更加容易。 C ++是C的一个扩展，它几乎是不可能学习C++不先学C。
```

In this article, we will walk through the entire language and show you how to become a C programmer, starting at the beginning. You will be amazed at all of the different things you can create once you know C!

```
在本文中，我们将穿行于整个语言，并告诉你如何成为一个C程序员，从头开始。你会惊奇地发现所有的不同的东西，你可以创建，一旦你熟悉C！

```

[c-exec]()

This animation shows the execution of a simple C program. By the end of this article you will understand how it works!

```
该动画显示了一个简单的C程序的执行。通过这篇文章的末尾，你就会明白它是如何工作的！
```


##What is C?

C is a **computer programming language**. That means that you can use C to create lists of instructions for a computer to follow. C is one of thousands of programming languages currently in use. C has been around for several decades and has won widespread acceptance because it gives programmers maximum control and efficiency. C is an easy language to learn. It is a bit more cryptic in its style than some other languages, but you get beyond that fairly quickly.

```

```

C is what is called a **compiled language**. This means that once you write your C program, you must run it through a **C compiler** to turn your program into an **executable** that the computer can run (execute). The C program is the human-readable form, while the executable that comes out of the compiler is the machine-readable and executable form. What this means is that to write and run a C program, you must have access to a C compiler. If you are using a UNIX machine (for example, if you are writing CGI scripts in C on your host's UNIX computer, or if you are a student working on a lab's UNIX machine), the C compiler is available for free. It is called either "cc" or "gcc" and is available on the command line. If you are a student, then the school will likely provide you with a compiler -- find out what the school is using and learn about it. If you are working at home on a Windows machine, you are going to need to download a free C compiler or purchase a commercial compiler. A widely used commercial compiler is Microsoft's Visual C++ environment (it compiles both C and C++ programs). Unfortunately, this program costs several hundred dollars. If you do not have hundreds of dollars to spend on a commercial compiler, then you can use one of the free compilers available on the Web. See http://delorie.com/djgpp/ as a starting point in your search.

```

```

We will start at the beginning with an extremely simple C program and build up from there. I will assume that you are using the UNIX command line and gcc as your environment for these examples; if you are not, all of the code will still work fine -- you will simply need to understand and use whatever compiler you have available.


##Let's get started!
====================

###The Simplest C Program

Let's start with the simplest possible C program and use it both to understand the basics of C and the C compilation process. Type the following program into a standard text editor (vi or emacs on UNIX, Notepad on Windows or TeachText on a Macintosh). Then save the program to a file named **samp.c**. If you leave off .c, you will probably get some sort of error when you compile it, so make sure you remember the .c. Also, make sure that your editor does not automatically append some extra characters (such as .txt) to the name of the file. Here's the first program:


```
#include <stdio.h>

int main()
{
    printf("This is output from my first program!\n");
    return 0;
}
```

When executed, this program instructs the computer to print out the line "This is output from my first program!" -- then the program quits. You can't get much simpler than that!

```

```

To compile this code, take the following steps:

* On a UNIX machine, **type gcc samp.c -o samp** (if gcc does not work, try cc). This line invokes the C compiler called gcc, asks it to compile samp.c and asks it to place the executable file it creates under the name **samp**. To run the program, type **samp** (or, on some UNIX machines, **./samp**).

* On a DOS or Windows machine using DJGPP, at an MS-DOS prompt type **gcc samp.c -o samp.exe**. This line invokes the C compiler called gcc, asks it to compile samp.c and asks it to place the executable file it creates under the name **samp.exe**. To run the program, type **samp**.

* If you are working with some other compiler or development system, read and follow the directions for the compiler you are using to compile and execute the program.

You should see the output "This is output from my first program!" when you run the program. Here is what happened when you compiled the program:

```

```

If you mistype the program, it either will not compile or it will not run. If the program does not compile or does not run correctly, edit it again and see where you went wrong in your typing. Fix the error and try again.

```

```

[c-compile]()

*A computer program is the key to the digital city: If you know the language, you can get a computer to do almost anything you want. Learn how to write computer programs in C.*



###The Simplest C Program: What's Happening?

Let's walk through this program and start to see what the different lines are doing (Click here to open the program in another window):

* This C program starts with **#include <stdio.h>**. This line **includes** the "standard I/O library" into your program. The standard I/O library lets you read input from the keyboard (called "standard in"), write output to the screen (called "standard out"), process text files stored on the disk, and so on. It is an extremely useful library. C has a large number of standard libraries like stdio, including string, time and math libraries. A **library** is simply a package of code that someone else has written to make your life easier (we'll discuss libraries a bit later).

* The line **int main()** declares the main function. Every C program must have a function named **main** somewhere in the code. We will learn more about functions shortly. At run time, program execution starts at the first line of the main function.

* In C, the **{** and **}** symbols mark the beginning and end of a block of code. In this case, the block of code making up the main function contains two lines.

* The **printf** statement in C allows you to send output to standard out (for us, the screen). The portion in quotes is called the **format string** and describes how the data is to be formatted when printed. The format string can contain string literals such as "This is output from my first program!," symbols for carriage returns (\n), and operators as placeholders for variables (see below). If you are using UNIX, you can type **man 3 printf** to get complete documentation for the printf function. If not, see the documentation included with your compiler for details about the printf function.

* The **return 0;** line causes the function to return an error code of 0 (no error) to the shell that started execution. More on this capability a bit later.


###Variables

As a programmer, you will frequently want your program to "remember" a value. For example, if your program requests a value from the user, or if it calculates a value, you will want to remember it somewhere so you can use it later. The way your program remembers things is by using **variables**. For example:

> int b;

This line says, "I want to create a space called b that is able to hold one integer value." A variable has a name (in this case, b) and a type (in this case, int, an integer). You can store a value in b by saying something like:

> b = 5;

You can use the value in b by saying something like:

> printf("%d", b);

In C, there are several standard types for variables:

> * **int** - integer (whole number) values
> * **float** - floating point values
> * **char** - single character values (such as "m" or "Z")

We will see examples of these other types as we go along.



###Printf

The **printf statement allows you to send output to standard out**. For us, standard out is generally the screen (although you can redirect standard out into a text file or another command).

Here is another program that will help you learn more about printf:

```
#include <stdio.h>

int main()
{
    int a, b, c;
    a = 5;
    b = 7;
    c = a + b;
    printf("%d + %d = %d\n", a, b, c);
    return 0;
}
```

Type this program into a file and save it as **add.c**. Compile it with the line **gcc add.c -o add** and then run it by typing **add** (or **./add**). You will see the line "5 + 7 = 12" as output.
