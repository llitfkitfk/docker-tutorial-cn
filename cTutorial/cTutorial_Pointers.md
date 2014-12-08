###Pointers

Pointers are used everywhere in C, so if you want to use the C language fully you have to have a very good understanding of pointers. They have to become comfortable for you. The goal of this section and the next several that follow is to help you build a complete understanding of pointers and how C uses them. For most people it takes a little time and some practice to become fully comfortable with pointers, but once you master them you are a full-fledged C programmer.

C uses pointers in three different ways:

* C uses pointers to create **dynamic data structures** -- data structures built up from blocks of memory allocated from the heap at run-time.
* C uses pointers to handle **variable parameters** passed to functions.
* Pointers in C provide an alternative way to **access information stored in arrays**. Pointer techniques are especially valuable when you work with strings. There is an intimate link between arrays and pointers in C.

In some cases, C programmers also use pointers because they make the code slightly more efficient. What you will find is that, once you are completely comfortable with pointers, you tend to use them all the time.

We will start this discussion with a basic introduction to pointers and the concepts surrounding pointers, and then move on to the three techniques described above. Especially on this article, you will want to read things twice. The first time through you can learn all the concepts. The second time through you can work on binding the concepts together into an integrated whole in your mind. After you make your way through the material the second time, it will make a lot of sense.



###Pointers: Why?

Imagine that you would like to create a **text editor** -- a program that lets you edit normal ASCII text files, like "vi" on UNIX or "Notepad" on Windows. A text editor is a fairly common thing for someone to create because, if you think about it, a text editor is probably a programmer's most commonly used piece of software. The text editor is a programmer's intimate link to the computer -- it is where you enter all of your thoughts and then manipulate them. Obviously, with anything you use that often and work with that closely, you want it to be just right. Therefore many programmers create their own editors and customize them to suit their individual working styles and preferences.

So one day you sit down to begin working on your editor. After thinking about the features you want, you begin to think about the "data structure" for your editor. That is, you begin thinking about how you will store the document you are editing in memory so that you can manipulate it in your program. What you need is a way to store the information you are entering in a form that can be manipulated quickly and easily. You believe that one way to do that is to organize the data on the basis of lines of characters. Given what we have discussed so far, the only thing you have at your disposal at this point is an array. You think, "Well, a typical line is 80 characters long, and a typical file is no more than 1,000 lines long." You therefore declare a **two-dimensional array**, like this:

```
char doc[1000][80];
```

This declaration requests an array of 1,000 80-character lines. This array has a total size of 80,000 characters.

As you think about your editor and its data structure some more, however, you might realize three things:

* Some documents are long lists. Every line is short, but there are thousands of lines.
* Some special-purpose text files have very long lines. For example, a certain data file might have lines containing 542 characters, with each character representing the amino acid pairs in segments of DNA.
* In most modern editors, you can open multiple files at one time.

Let's say you set a maximum of 10 open files at once, a maximum line length of 1,000 characters and a maximum file size of 50,000 lines. Your declaration now looks like this:

```
char doc[50000][1000][10];
```

That doesn't seem like an unreasonable thing, until you pull out your calculator, multiply 50,000 by 1,000 by 10 and realize the array contains 500 million characters! Most computers today are going to have a problem with an array that size. They simply do not have the RAM, or even the virtual memory space, to support an array that large. If users were to try to run three or four copies of this program simultaneously on even the largest multi-user system, it would put a severe strain on the facilities.

Even if the computer would accept a request for such a large array, you can see that it is an extravagant waste of space. It seems strange to declare a 500 million character array when, in the vast majority of cases, you will run this editor to look at 100 line files that consume at most 4,000 or 5,000 bytes. The problem with an array is the fact that **you have to declare it to have its maximum size in every dimension from the beginning**. Those maximum sizes often multiply together to form very large numbers. Also, if you happen to need to be able to edit an odd file with a 2,000 character line in it, you are out of luck. There is really no way for you to predict and handle the maximum line length of a text file, because, technically, that number is infinite.

Pointers are designed to solve this problem. With pointers, you can create **dynamic data structures**. Instead of declaring your worst-case memory consumption up-front in an array, you instead **allocate** memory from **the heap** while the program is running. That way you can use the exact amount of memory a document needs, with no waste. In addition, when you close a document you can return the memory to the heap so that other parts of the program can use it. With pointers, memory can be recycled while the program is running.

By the way, if you read the previous discussion and one of the big questions you have is, "What IS a byte, really?," then the article How Bits and Bytes Work will help you understand the concepts, as well as things like "mega," "giga" and "tera." Go take a look and then come back.


###Pointer Basics

![](https://github.com/llitfkitfk/docker-tutorial-cn/blob/master/ref/c-pointer1.gif)

To understand pointers, it helps to compare them to normal variables.

A "normal variable" is a location in memory that can hold a value. For example, when you declare a variable **i** as an integer, four bytes of memory are set aside for it. In your program, you refer to that location in memory by the name **i**. At the machine level that location has a memory address. The four bytes at that address are known to you, the programmer, as **i**, and the four bytes can hold one integer value.

A pointer is different. A pointer is a variable that **points** to another variable. This means that a pointer holds the memory address of another variable. Put another way, the pointer does not hold a value in the traditional sense; instead, it holds the address of another variable. A pointer "points to" that other variable by holding a copy of its address.

Because a pointer holds an address rather than a value, it has two parts. The pointer itself holds the address. That address points to a value. There is the pointer and the value pointed to. This fact can be a little confusing until you get comfortable with it, but once you get comfortable it becomes extremely powerful.

The following example code shows a typical pointer:

```
#include <stdio.h>

int main()
{
    int i,j;
    int *p;   /* a pointer to an integer */
    p = &i;
    *p=5;
    j=i;
    printf("%d %d %d\n", i, j, *p);
    return 0;
}
```

The first declaration in this program declares two normal integer variables named **i** and **j**. The line **int \*p** declares a pointer named **p**. This line asks the compiler to declare a variable **p** that is a **pointer** to an integer. The * indicates that a pointer is being declared rather than a normal variable. You can create a pointer to anything: a float, a structure, a char, and so on. Just use a * to indicate that you want a pointer rather than a normal variable.

The line **p = &i;** will definitely be new to you. In C, **&** is called the **address operator**. The expression **&i** means, "The memory address of the variable **i**." Thus, the expression **p = &i;** means, "Assign to **p** the address of **i**." Once you execute this statement, **p** "points to" **i**. Before you do so, **p** contains a random, unknown address, and its use will likely cause a segmentation fault or similar program crash.

One good way to visualize what is happening is to draw a picture. After **i**, **j** and **p** are declared, the world looks like the image above.

In this drawing the three variables **i**, **j** and **p** have been declared, but none of the three has been initialized. The two integer variables are therefore drawn as boxes containing question marks -- they could contain any value at this point in the program's execution. The pointer is drawn as a circle to distinguish it from a normal variable that holds a value, and the random arrows indicate that it can be pointing anywhere at this moment.

After the line **p = &I;**, **p** is initialized and it points to **i**, like this:

![](https://github.com/llitfkitfk/docker-tutorial-cn/blob/master/ref/c-pointer2.gif)
![](https://github.com/llitfkitfk/docker-tutorial-cn/blob/master/ref/c-pointer3.gif)
 
Once **p** points to **i**, the memory location **i** has two names. It is still known as **i**, but now it is known as **\*p** as well. This is how C talks about the two parts of a pointer variable: **p** is the location holding the address, while **\*p** is the location pointed to by that address. Therefore **\*p=5** means that the location pointed to by p should be set to 5, like this:
 
Because the location **\*p** is also **i**, **i** also takes on the value 5. Consequently, **j=i;** sets **j** to 5, and the printf statement produces **5 5 5**.

The main feature of a pointer is its two-part nature. The pointer itself holds an address. The pointer also points to a value of a specific type - the value at the address the point holds. The pointer itself, in this case, is **p**. The value pointed to is **\*p**.



![](https://github.com/llitfkitfk/docker-tutorial-cn/blob/master/ref/c-pointer4.gif)

###Pointers: Understanding Memory Addresses

The previous discussion becomes a little clearer if you understand how memory addresses work in a computer's hardware. If you have not read it already, now would be a good time to read How Bits and Bytes Work to fully understand bits, bytes and words.

All computers have **memory**, also known as **RAM** (random access memory). For example, your computer might have 16 or 32 or 64 megabytes of RAM installed right now. RAM holds the programs that your computer is currently running along with the data they are currently manipulating (their variables and data structures). Memory can be thought of simply as an array of bytes. In this array, every memory location has its own address -- the address of the first byte is 0, followed by 1, 2, 3, and so on. Memory addresses act just like the indexes of a normal array. The computer can access any address in memory at any time (hence the name "random access memory"). It can also group bytes together as it needs to to form larger variables, arrays, and structures. For example, a floating point variable consumes 4 contiguous bytes in memory. You might make the following global declaration in a program:

```
float f;
```

This statement says, "Declare a location named **f** that can hold one floating point value." When the program runs, the computer reserves space for the variable **f** somewhere in memory. That location has a fixed address in the memory space, like this:

While you think of the variable **f**, the computer thinks of a specific address in memory (for example, 248,440). Therefore, when you create a statement like this:

```
f = 3.14;
```

The compiler might translate that into, "Load the value 3.14 into memory location 248,440." The computer is always thinking of memory in terms of addresses and values at those addresses.

There are, by the way, several interesting side effects to the way your computer treats memory. For example, say that you include the following code in one of your programs:

```
int i, s[4], t[4], u=0;

for (i=0; i<=4; i++)
{
	s[i] = i;
	t[i] =i;
}
printf("s:t\n");
for (i=0; i<=4; i++)
	printf("%d:%d\n", s[i], t[i]);
printf("u = %d\n", u);
```

The output that you see from the program will probably look like this:

```
s:t
1:5
2:2
3:3
4:4
5:5
u = 5
```

Why are **t[0]** and **u** incorrect? If you look carefully at the code, you can see that the for loops are writing one element past the end of each array. In memory, the arrays are placed adjacent to one another, as shown here:
 
![](https://github.com/llitfkitfk/docker-tutorial-cn/blob/master/ref/c-pointer5.gif)

> Arrays placed adjacent to one another


Therefore, when you try to write to s[4], which does not exist, the system writes into t[0] instead because t[0] is where s[4] ought to be. When you write into t[4], you are really writing into u. As far as the computer is concerned, s[4] is simply an address, and it can write into it. As you can see however, even though the computer executes the program, it is not correct or valid. The program corrupts the array t in the process of running. If you execute the following statement, more severe consequences result:

```
s[1000000] = 5;
```

The location **s[1000000]** is more than likely outside of your program's memory space. In other words, you are writing into memory that your program does not own. On a system with protected memory spaces (UNIX, Windows 98/NT), this sort of statement will cause the system to terminate execution of the program. On other systems (Windows 3.1, the Mac), however, the system is not aware of what you are doing. You end up damaging the code or variables in another application. The effect of the violation can range from nothing at all to a complete system crash. In memory, i, s, t and u are all placed next to one another at specific addresses. Therefore, if you write past the boundaries of a variable, the computer will do what you say but it will end up corrupting another memory location.

Because C and C++ do not perform any sort of range checking when you access an element of an array, it is essential that you, as a programmer, pay careful attention to **array ranges** yourself and keep within the array's appropriate boundaries. Unintentionally reading or writing outside of array boundaries always leads to faulty program behavior.

As another example, try the following:

```
#include <stdio.h>

int main()
{
    int i,j;
    int *p;   /* a pointer to an integer */
    printf("%d %d\n", p, &i);
    p = &i;
    printf("%d %d\n", p, &i);
    return 0;
}
```

This code tells the compiler to print out the address held in **p**, along with the address of **i**. The variable **p** starts off with some crazy value or with 0. The address of **i** is generally a large value. For example, when I ran this code, I received the following output:

```
0   2147478276
2147478276   2147478276
```
which means that the address of i is 2147478276. Once the statement **p = &i;** has been executed, **p** contains the address of **i**. Try this as well:

```
#include <stdio.h>

void main()
{
    int *p;   /* a pointer to an integer */

    printf("%d\n",*p);
}
```

This code tells the compiler to print the value that **p** points to. However, **p** has not been initialized yet; it contains the address 0 or some random address. In most cases, a **segmentation fault** (or some other run-time error) results, which means that you have used a pointer that points to an invalid area of memory. Almost always, an uninitialized pointer or a bad pointer address is the cause of segmentation faults.

Having said all of this, we can now look at pointers in a whole new light. Take this program, for example:

```
#include <stdio.h>

int main()
{
    int i;
    int *p;   /* a pointer to an integer */
    p = &i;
    *p=5;
    printf("%d %d\n", i, *p);
    return 0;
}
```

Here is what's happening:
 
![](https://github.com/llitfkitfk/docker-tutorial-cn/blob/master/ref/c-pointer6.gif)


The variable **i** consumes 4 bytes of memory. The pointer p also consumes 4 bytes (on most machines in use today, a pointer consumes 4 bytes of memory. Memory addresses are 32-bits long on most CPUs today, although there is a increasing trend toward 64-bit addressing). The location of i has a specific address, in this case 248,440. The pointer p holds that address once you say **p = &i;**. The variables **\*p** and **i** are therefore equivalent.

The pointer **p** literally holds the address of **i**. When you say something like this in a program:

```
printf("%d", p);
```

what comes out is the actual address of the variable **i**.


###Pointers: Pointing to the Same Address

![](https://github.com/llitfkitfk/docker-tutorial-cn/blob/master/ref/c-pointer7.gif)

Here is a cool aspect of C: **Any number of pointers can point to the same address**. For example, you could declare p, q, and r as integer pointers and set all of them to point to i, as shown here:

```
int i;
int *p, *q, *r;

p = &i;
q = &i;
r = p;
```
Note that in this code, r points to the same thing that p points to, which is **i**. You can assign pointers to one another, and the address is copied from the right-hand side to the left-hand side during the assignment. After executing the above code, this is how things would look:
The variable i now has four names: i, *p, *q and *r. There is no limit on the number of pointers that can hold (and therefore point to) the same address.


###Pointers: Common Bugs

####Bug #1 - Uninitialized pointers

One of the easiest ways to create a pointer bug is to try to reference the value of a pointer even though the pointer is uninitialized and does not yet point to a valid address. For example:

```
int *p;
*p = 12;
```

The pointer **p** is uninitialized and points to a random location in memory when you declare it. It could be pointing into the system stack, or the global variables, or into the program's code space, or into the operating system. When you say **\*p=12;**, the program will simply try to write a 12 to whatever random location **p** points to. The program may explode immediately, or may wait half an hour and then explode, or it may subtly corrupt data in another part of your program and you may never realize it. This can make this error very hard to track down. Make sure you initialize all pointers to a valid address before dereferencing them.

####Bug #2 - Invalid Pointer References

An invalid pointer reference occurs when a pointer's value is referenced even though the pointer doesn't point to a valid block.
One way to create this error is to say **p=q;**, when **q** is uninitialized. The pointer p will then become uninitialized as well, and any reference to *p is an invalid pointer reference.
The only way to avoid this bug is to draw pictures of each step of the program and make sure that all pointers point somewhere. Invalid pointer references cause a program to crash inexplicably for the same reasons given in Bug #1.

####Bug #3 - Zero Pointer Reference

A zero pointer reference occurs whenever a pointer pointing to zero is used in a statement that attempts to reference a block. For example, if **p** is a pointer to an integer, the following code is invalid:

```
p = 0;
*p = 12;
```

There is no block pointed to by p. Therefore, trying to read or write anything from or to that block is an invalid zero pointer reference. There are good, valid reasons to point a pointer to zero, as we will see in later articles. Dereferencing such a pointer, however, is invalid.

All of these bugs are fatal to a program that contains them. You must watch your code so that these bugs do not occur. The best way to do that is to draw pictures of the code's execution step by step.


###Using Pointers for Function Parameters

![](https://github.com/llitfkitfk/docker-tutorial-cn/blob/master/ref/c-pointer-swap.gif)

Most C programmers first use pointers to implement something called **variable parameters** in functions. You have actually been using variable parameters in the scanf function -- that's why you've had to use the **&** (the address operator) on variables used with scanf. Now that you understand pointers you can see what has really been going on.

To understand how variable parameters work, lets see how we might go about implementing a swap function in C. To implement a **swap** function, what you would like to do is pass in two variables and have the function swap their values. Here's one attempt at an implementation -- enter and execute the following code and see what happens:

```
#include <stdio.h>

void swap(int i, int j)
{
    int t;

    t=i;
    i=j;
    j=t;
}

void main()
{
    int a,b;

    a=5;
    b=10;
    printf("%d %d\n", a, b);
    swap(a,b);
    printf("%d %d\n", a, b);
}
```

When you execute this program, you will find that no swapping takes place. The values of **a** and **b** are passed to swap, and the swap function does swap them, but when the function returns nothing happens.

To make this function work correctly you can use pointers, as shown below:

```
#include <stdio.h>

void swap(int *i, int *j)
{
    int t;
    t = *i;
    *i = *j;
    *j = t;
}

void main()
{
    int a,b;
    a=5;
    b=10;
    printf("%d %d\n",a,b);
    swap(&a,&b);
    printf("%d %d\n",a,b);
}
```

To get an idea of what this code does, print it out, draw the two integers **a** and **b**, and enter 5 and 10 in them. Now draw the two pointers **i** and **j**, along with the integer **t**. When **swap** is called, it is passed the addresses of **a** and **b**. Thus, **i** points to **a** (draw an arrow from **i** to **a**) and **j** points to **b** (draw another arrow from **b** to **j**). Once the pointers are initialized by the function call, **\*i** is another name for **a**, and **\*j** is another name for **b**. Now run the code in **swap**. When the code uses **\*i** and **\*j**, it really means **a** and **b**. When the function completes, a and b have been swapped.

Suppose you accidentally forget the **&** when the **swap** function is called, and that the **swap** line accidentally looks like this: **swap(a, b);**. This causes a segmentation fault. When you leave out the **&**, the value of **a** is passed instead of its address. Therefore, **i** points to an invalid location in memory and the system crashes when **\*i** is used.

This is also why **scanf** crashes if you forget the **&** on variables passed to it. The **scanf** function is using pointers to put the value it reads back into the variable you have passed. Without the **&**, **scanf** is passed a bad address and crashes.

Variable parameters are one of the most common uses of pointers in C. Now you understand what's happening!