##Introduction to the Basics of C Programming

| 目录 | 内容
|:------:|:----------:
|第一章  | [简介](https://github.com/llitfkitfk/docker-tutorial-cn/blob/master/CTutorial.md)
|第二章  | [Branching and Looping（分支与循环）](https://github.com/llitfkitfk/docker-tutorial-cn/blob/master/cTutorial/cTutorial_Looping.md)
|第三章  | [Arrays（数组）](https://github.com/llitfkitfk/docker-tutorial-cn/blob/master/cTutorial/cTutorial_Array.md)
|第四章  | [Functions（函数）](https://github.com/llitfkitfk/docker-tutorial-cn/blob/master/cTutorial/cTutorial_Functions.md)
|第五章  | [Libraries（库）](https://github.com/llitfkitfk/docker-tutorial-cn/blob/master/cTutorial/cTutorial_Libraries.md)
|第六章  | [Makefiles（Makefiles）](https://github.com/llitfkitfk/docker-tutorial-cn/blob/master/cTutorial/cTutorial_Makefiles.md)
|第七章  | [Text Files（文本文件）](https://github.com/llitfkitfk/docker-tutorial-cn/blob/master/cTutorial/cTutorial_TextFiles.md)
|第八章  | [Pointers（指针）](https://github.com/llitfkitfk/docker-tutorial-cn/blob/master/cTutorial/cTutorial_Pointers.md)
|第九章  | [Dynamic Data Structures（数据结构）](https://github.com/llitfkitfk/docker-tutorial-cn/blob/master/cTutorial/cTutorial_DDS.md)
|第十章  | [Advanced Pointers](https://github.com/llitfkitfk/docker-tutorial-cn/blob/master/cTutorial/cTutorial_AdvPointers.md)
|第十一章  | [Strings](https://github.com/llitfkitfk/docker-tutorial-cn/blob/master/cTutorial/cTutorial_Strings.md)
|第十二章  | [Operator Precedence](https://github.com/llitfkitfk/docker-tutorial-cn/blob/master/cTutorial/cTutorial_OperatorP.md)
|第十三章  | [Command Line Arguments](https://github.com/llitfkitfk/docker-tutorial-cn/blob/master/cTutorial/cTutorial_CLA.md)
|第十四章  | [Binary Files](https://github.com/llitfkitfk/docker-tutorial-cn/blob/master/cTutorial/cTutorial_BFiles.md)


The C programming language is a popular and widely used programming language for creating **computer programs**. Programmers around the world embrace C because it gives maximum control and efficiency to the programmer.

```
C语言是一种流行和广泛使用的编程语言，用于创建计算机程序。
世界各地的程序员拥抱C，因为它给程序员提供了最大的控制和效率。
```
If you are a programmer, or if you are interested in becoming a programmer, there are a couple of benefits you gain from learning C:

* You will be able to read and write code for a large number of platforms -- everything from microcontrollers to the most advanced scientific systems can be written in C, and many modern operating systems are written in C.
* The jump to the object oriented C++ language becomes much easier. C++ is an extension of C, and it is nearly impossible to learn C++ without learning C first.

```
如果你是一个程序员，或者如果你有兴趣成为一名程序员，这里有学习C的几个好处：

-> 您可以为大量的平台阅读和编写代码 - 
	从微控制器到最先进的科学系统，都可以用C语言编写，并且许多现代操作系统都也是用C语言编写的.

-> 转到面向对象的C++语言会变得更加容易。 
	C++是C的一个扩展，学习C++而不学C几乎是不可能的。
```

In this article, we will walk through the entire language and show you how to become a C programmer, starting at the beginning. You will be amazed at all of the different things you can create once you know C!

```
在本文中，我们将穿行于整个语言，从头开始教会你如何成为一个C程序员。一旦你熟悉C，你会惊奇地发现所有的不同的东西你都可以创建！

```

![](https://github.com/llitfkitfk/docker-tutorial-cn/blob/master/ref/c-exec.gif)

This animation shows the execution of a simple C program. By the end of this article you will understand how it works!

```
该动画显示了一个简单的C程序的执行。
看完这篇文章，你就会明白它是如何工作的！
```


##What is C?

C is a **computer programming language**. That means that you can use C to create lists of instructions for a computer to follow. C is one of thousands of programming languages currently in use. C has been around for several decades and has won widespread acceptance because it gives programmers maximum control and efficiency. C is an easy language to learn. It is a bit more cryptic in its style than some other languages, but you get beyond that fairly quickly.

```
C是一个的计算机编程语言。这意味着你可以用C来创建一系列的指令。 
C是成千上万的编程语言中当前使用的一个。 
C已经存在了几十年，并赢得了广泛的认可，因为它为程序员提供了最大程度的控制和效率。 
C是一种容易学的语言，风格上来讲它更隐蔽相比其他一些语言，但你会很快超越它。
```

C is what is called a **compiled language**. This means that once you write your C program, you must run it through a **C compiler** to turn your program into an **executable** that the computer can run (execute). The C program is the human-readable form, while the executable that comes out of the compiler is the machine-readable and executable form. What this means is that to write and run a C program, you must have access to a C compiler. If you are using a UNIX machine (for example, if you are writing CGI scripts in C on your host's UNIX computer, or if you are a student working on a lab's UNIX machine), the C compiler is available for free. It is called either "cc" or "gcc" and is available on the command line. If you are a student, then the school will likely provide you with a compiler -- find out what the school is using and learn about it. If you are working at home on a Windows machine, you are going to need to download a free C compiler or purchase a commercial compiler. A widely used commercial compiler is Microsoft's Visual C++ environment (it compiles both C and C++ programs). Unfortunately, this program costs several hundred dollars. If you do not have hundreds of dollars to spend on a commercial compiler, then you can use one of the free compilers available on the Web. See http://delorie.com/djgpp/ as a starting point in your search.

```
C是所谓的编译语言。这意味着，一旦你写了C程序，您必须通过一个C编译器运行它来把你的程序转换成计算机可以运行的程序。 
C程序是人类可读的格式，而编译器编译出的可执行文件是机器可读和可执行格式。
这意味着，要编写和运行一个C程序，您必须有一个能够访问的C编译器。如果您使用的是UNIX机器（例如，如果您是在用您的UNIX计算机上编写CGI脚本C，或者如果你是用实验室的UNIX机器的学生），C编译器是免费提供的。它被称为或者“cc”或“gcc”，并且是可用在命令行上。
如果你是学生，那么学校可能会为你提供一个编译器 - 找出哪些学校是使用和了解它。
如果你是在家里工作在Windows机器上，你将需要下载一个免费的C编译器，或购买商业编译器。
一种广泛应用于商业编译器是微软的Visual C++环境（它编译C和C++程序）。
不幸的是，这个方案的成本几百元。如果你没有几十块钱把钱花在商业编译器，那么你可以使用一种在Web上提供免费的编译器。见http://delorie.com/djgpp/。
(译注：用mac的同学，可以下载xcode自带编译器)

```

We will start at the beginning with an extremely simple C program and build up from there. I will assume that you are using the UNIX command line and gcc as your environment for these examples; if you are not, all of the code will still work fine -- you will simply need to understand and use whatever compiler you have available.

```
我们将从头开始编写一个非常简单的C程序。
我将假定您正在使用UNIX命令行和gcc作为环境这些例子;
如果你不是，所有的代码仍然会正常工作 - 你只需要简单地理解和使用你已经获得的编译器。
```


##Let's get started!
====================

###The Simplest C Program

Let's start with the simplest possible C program and use it both to understand the basics of C and the C compilation process. Type the following program into a standard text editor (vi or emacs on UNIX, Notepad on Windows or TeachText on a Macintosh). Then save the program to a file named **samp.c**. If you leave off .c, you will probably get some sort of error when you compile it, so make sure you remember the .c. Also, make sure that your editor does not automatically append some extra characters (such as .txt) to the name of the file. 

```
让我们先从最简单的C程序开始，用它既能理解C的基础知识和C编译过程。键入下面的程序保存到一个标准的文本编辑器（UNIX的vi或emacs，Windows上的Notepad 或者 Mac OX 的Text editor）。
然后，该程序保存为 samp.c的文件。如果您不加后缀.c，编译它时你可能会得到某种错误时，所以一定要记得带上后缀名.c。
此外，请确保您的编辑器不会自动添加一些额外的字符（如.txt后缀）的文件的名称。
```

Here's the first program:

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
在执行时，该程序指令计算机打印出一行“This is output from my first program!” - 然后该程序退出。
就是如此简单！
```

To compile this code, take the following steps:

* On a UNIX machine, **type gcc samp.c -o samp** (if gcc does not work, try cc). This line invokes the C compiler called gcc, asks it to compile samp.c and asks it to place the executable file it creates under the name **samp**. To run the program, type **samp** (or, on some UNIX machines, **./samp**).

* On a DOS or Windows machine using DJGPP, at an MS-DOS prompt type **gcc samp.c -o samp.exe**. This line invokes the C compiler called gcc, asks it to compile samp.c and asks it to place the executable file it creates under the name **samp.exe**. To run the program, type **samp**.

* If you are working with some other compiler or development system, read and follow the directions for the compiler you are using to compile and execute the program.

```
编译此代码，请执行以下步骤：

-> 在UNIX机器上，键入
	gcc samp.c －o samp（如果GCC不工作，尝试cc）。
该行调用C的编译器叫gcc，用它来编译samp.c并把创建的执行文件命名为samp。要运行该程序，输入 samp（或者在某些UNIX机器：./samp）。

-> 使用 DOS或Windows机器，在MS-DOS提示符下键入
	gcc samp.c -o samp.exe。
该行调用的C编译器叫gcc，用它来编译samp.c并把创建的执行文件命名为samp.exe。要运行该程序, 输入samp。

-> 如果您正在使用其他的编译器或开发系统，阅读并遵照您使用的编译器的规范去执行程序。
```

![](https://github.com/llitfkitfk/docker-tutorial-cn/blob/master/ref/c-compile.gif)

*A computer program is the key to the digital city: If you know the language, you can get a computer to do almost anything you want. Learn how to write computer programs in C.*

```
计算机程序的关键是数字：如果你了解语言，你可以用电脑做几乎任何你想要的。了解如何用C编写的计算机程序。

```

You should see the output "This is output from my first program!" when you run the program. Here is what happened when you compiled the program:

If you mistype the program, it either will not compile or it will not run. If the program does not compile or does not run correctly, edit it again and see where you went wrong in your typing. Fix the error and try again.

```
您应该看到输出“This is output from my first program!”, 当您运行该程序。
下面是当你编译的程序发生了什么：

如果输错了程序，它要么将无法编译，要么将无法运行。
如果程序没有编译或运行不正常，重新编辑一下，看看你在哪里错在你打字。修复错误，然后重试。

```

> **POSITION**
> 
> *When you enter this program, position **#include** so that the pound sign is in column 1 (the far left side). Otherwise, the spacing and indentation can be any way you like it. On some UNIX systems, you will find a program called **cb**, the C Beautifier, which will format code for you. The spacing and indentation shown above is a good example to follow.*

```
```

> **位置**

> *当你进入这个程序，放置#include在第1列（最左侧）。其他的随意加间距和缩进都可以。
在一些UNIX系统中，你会发现一个叫cb的程序，C Beautifier，该计划可以格式化代码为你。如上图所示的间距和缩进就是一个很好的例子。*

###The Simplest C Program: What's Happening?

Let's walk through this program and start to see what the different lines are doing (Click here to open the program in another window):

* This C program starts with **#include <stdio.h>**. This line **includes** the "standard I/O library" into your program. The standard I/O library lets you read input from the keyboard (called "standard in"), write output to the screen (called "standard out"), process text files stored on the disk, and so on. It is an extremely useful library. C has a large number of standard libraries like stdio, including string, time and math libraries. A **library** is simply a package of code that someone else has written to make your life easier (we'll discuss libraries a bit later).
* The line **int main()** declares the main function. Every C program must have a function named **main** somewhere in the code. We will learn more about functions shortly. At run time, program execution starts at the first line of the main function.
* In C, the **{** and **}** symbols mark the beginning and end of a block of code. In this case, the block of code making up the main function contains two lines.
* The **printf** statement in C allows you to send output to standard out (for us, the screen). The portion in quotes is called the **format string** and describes how the data is to be formatted when printed. The format string can contain string literals such as "This is output from my first program!" symbols for carriage returns (\n), and operators as placeholders for variables (see below). If you are using UNIX, you can type **man 3 printf** to get complete documentation for the printf function. If not, see the documentation included with your compiler for details about the printf function.
* The **return 0;** line causes the function to return an error code of 0 (no error) to the shell that started execution. More on this capability a bit later.

```
让我们通过这一程序，来看一下不同行都在在做什么：

-> 这个C程序开始于 #include <stdio.h> 。该行includes把“标准I / O库”放到你的程序里。标准I/ O库可以让程序从键盘读取（所谓的“标准输入”）的输入，并把输出放到屏幕上（所谓的“标准输出”），处理存储在磁盘上的文本文件，等等。
这是一个非常有用的库。 C有大量的标准库，比如标准输入输出，包括字符串，时间和数学库。 library（库）仅仅是一个别人写的代码包，可以使您的生活更轻松（晚点儿我们会讨论库）。

->  int main() 声明了main函数。每个C程序都必须有一个叫main的函数。一会儿我们将了解更多函数。在运行时状态，程序的执行开始于main函数的第一行。

-> 在C语言中，{ 和 }的符号为标记代码块的开头和结尾。在这个程序里，代码main函数只有两行。

-> c语言里的printf语句允许你发送输出到标准输出（对我们来说，标准输出就是屏幕）。
引号中的部分被称为 格式字符串，是描述如何对数据进行格式化打印。
格式字符串可以包含字符串文字，如“This is output from my first program!”符号回车（\n）和操作的占位符变量（见下文）。
如果您使用的是UNIX，则可以键入man 3 printf，以便获得关于printf函数的完整的文档。如果不是，请参阅附带的编译器有关printf函数的详细信息的文档。

-> return 0; 行意思是执行该函数后返回的错误代码是 0（没有错误）。后面我们会了解更多的关于此功能。

```

###Variables

As a programmer, you will frequently want your program to "remember" a value. For example, if your program requests a value from the user, or if it calculates a value, you will want to remember it somewhere so you can use it later. The way your program remembers things is by using **variables**. For example:

```
int b;
```
This line says, "I want to create a space called b that is able to hold one integer value." A variable has a name (in this case, b) and a type (in this case, int, an integer). You can store a value in b by saying something like:

```
b = 5;
```
You can use the value in b by saying something like:

```
printf("%d", b);
```

In C, there are several standard types for variables:

* **int** - integer (whole number) values
* **float** - floating point values
* **char** - single character values (such as "m" or "Z")

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



Here is an explanation of the different lines in this program:

* The line **int a, b, c;** declares three integer variables named **a**, **b** and **c**. Integer variables hold whole numbers.

* The next line initializes the variable named **a** to the value 5.

* The next line sets **b** to 7.

* The next line adds **a** and **b** and "assigns" the result to c. The computer adds the value in **a** (5) to the value in **b** (7) to form the result 12, and then places that new value (12) into the variable c. The variable c is assigned the value 12. For this reason, the = in this line is called "the assignment operator."

* The **printf** statement then prints the line "5 + 7 = 12." The **%d** placeholders in the printf statement act as placeholders for values. There are three %d placeholders, and at the end of the printf line there are the three variable names: **a**, **b** and **c**. C matches up the first %d with a and substitutes 5 there. It matches the second %d with b and substitutes 7. It matches the third %d with c and substitutes 12. Then it prints the completed line to the screen: 5 + 7 = 12. The **+**, the = and the spacing are a part of the format line and get embedded automatically between the %d operators as specified by the programmer.


> **C ERRORS TO AVOID**
> 
> * *Using the wrong character case - Case matters in C, so you cannot type Printf or PRINTF. It must be printf.*
> * *Forgetting to use the & in scanf*
> * *Too many or too few parameters following the format statement in printf or scanf*
> * *Forgetting to declare a variable name before using it*


###Printf: Reading User Values

The previous program is good, but it would be better if it read in the values 5 and 7 from the user instead of using constants. Try this program instead:

```
#include <stdio.h>

int main()
{
    int a, b, c;
    printf("Enter the first value:");
    scanf("%d", &a);
    printf("Enter the second value:");
    scanf("%d", &b);
    c = a + b;
    printf("%d + %d = %d\n", a, b, c);
    return 0;
}
```

Here's how this program works when you execute it:

Make the changes, then compile and run the program to make sure it works. Note that scanf uses the same sort of format string as printf (type **man scanf** for more info). Also note the & in front of a and b. This is the **address operator** in C: It returns the address of the variable (this will not make sense until we discuss pointers). You must use the & operator in scanf on any variable of type char, int, or float, as well as structure types (which we will get to shortly). If you leave out the & operator, you will get an error when you run the program. Try it so that you can see what that sort of run-time error looks like.

Let's look at some variations to understand printf completely. Here is the simplest printf statement:

```
printf("Hello");
```
This call to printf has a format string that tells printf to send the word "Hello" to standard out. Contrast it with this:

```
printf("Hello\n");
```
The difference between the two is that the second version sends the word "Hello" followed by a carriage return to standard out.
The following line shows how to **output the value of a variable using printf**.

```
printf("%d", b);
```
The %d is a placeholder that will be replaced by the value of the variable b when the printf statement is executed. Often, you will want to embed the value within some other words. One way to accomplish that is like this:

```
printf("The temperature is ");
printf("%d", b);
printf(" degrees\n");
```
An easier way is to say this:

```
printf("The temperature is %d degrees\n", b);
```

You can also use multiple %d placeholders in one printf statement:

```
printf("%d + %d = %d\n", a, b, c);
```
In the printf statement, it is extremely important that the number of **operators** in the format string corresponds exactly with the number and type of the variables following it. For example, if the format string contains three %d operators, then it must be followed by exactly three parameters and they must have the same types in the same order as those specified by the operators.

You can **print all of the normal C types with printf** by using different placeholders:

* **int** (integer values) uses **%d**
* **float** (floating point values) uses **%f**
* **char** (single character values) uses **%c**
* **character strings** (arrays of characters, discussed later) use **%s**

You can learn more about the nuances of printf on a UNIX machine by typing **man 3 printf**. Any other C compiler you are using will probably come with a manual or a help file that contains a description of printf.



> **VARIATIONS**
> 
> *Try deleting or adding random characters or words in one of the previous programs and watch how the compiler reacts to these errors.*



###Scanf

The **scanf function allows you to accept input from standard in**, which for us is generally the keyboard. The scanf function can do a lot of different things, but it is generally unreliable unless used in the simplest ways. It is unreliable because it does not handle human errors very well. But for simple programs it is good enough and easy-to-use.


The simplest application of **scanf** looks like this:

```
scanf("%d", &b);
```
The program will read in an integer value that the user enters on the keyboard (%d is for integers, as is printf, so b must be declared as an int) and place that value into b.

The scanf function uses the same placeholders as printf:

```
int uses %d
float uses %f
char uses %c
character strings (discussed later) use %s
```

You MUST put **&** in front of the variable used in scanf. The reason why will become clear once you learn about **pointers**. It is easy to forget the & sign, and when you forget it your program will almost always crash when you run it.

In general, it is best to use scanf as shown here -- to read a single value from the keyboard. Use multiple calls to scanf to read multiple values. In any real program, you will use the **gets** or **fgets** functions instead to read text a line at a time. Then you will "parse" the line to read its values. The reason that you do that is so you can detect errors in the input and handle them as you see fit.

The printf and scanf functions will take a bit of practice to be completely understood, but once mastered they are extremely useful.


####Try This!
Modify this program so that it accepts three values instead of two and adds all three together:

```
#include <stdio.h>

int main()
{
    int a, b, c;
    printf("Enter the first value:");
    scanf("%d", &a);
    printf("Enter the second value:");
    scanf("%d", &b);
    c = a + b;
    printf("%d + %d = %d\n", a, b, c);
    return 0;
}
```
You can also delete the b variable in the first line of the above program and see what the compiler does when you forget to declare a variable. Delete a semicolon and see what happens. Leave out one of the braces. Remove one of the parentheses next to the main function. Make each error by itself and then run the program through the compiler to see what happens. By simulating errors like these, you can learn about different compiler errors, and that will make your typos easier to find when you make them for real.


| PREVIOURS	| TOP | NEXT
| :------: | :-------: | :------:
| [上一篇](https://github.com/llitfkitfk/docker-tutorial-cn/blob/master/CTutorial.md)  | [带我飞](https://github.com/llitfkitfk/docker-tutorial-cn/blob/master/CTutorial.md#introduction-to-the-basics-of-c-programming)| [下一篇](https://github.com/llitfkitfk/docker-tutorial-cn/blob/master/cTutorial/cTutorial_Looping.md)
