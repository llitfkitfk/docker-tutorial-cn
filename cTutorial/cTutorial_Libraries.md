Libraries
Libraries are very important in C because the C language supports only the most basic features that it needs. C does not even contain I/O functions to read from the keyboard and write to the screen. Anything that extends beyond the basic language must be written by a programmer. The resulting chunks of code are often placed in libraries to make them easily reusable. We have seen the standard I/O, or stdio, library already: Standard libraries exist for standard I/O, math functions, string handling, time manipulation, and so on. You can use libraries in your own programs to split up your programs into modules. This makes them easier to understand, test, and debug, and also makes it possible to reuse code from other programs that you write.
You can create your own libraries easily. As an example, we will take some code from a previous article in this series and make a library out of two of its functions. Here's the code we will start with:
#include <stdio.h>

#define MAX 10

int a[MAX];
int rand_seed=10;

int rand()
/* from K&R
   - produces a random number between 0 and 32767.*/
{
    rand_seed = rand_seed * 1103515245 +12345;
    return (unsigned int)(rand_seed / 65536) % 32768;
}

void main()
{
    int i,t,x,y;

    /* fill array */
    for (i=0; i < MAX; i++)
    {
        a[i]=rand();
        printf("%d\n",a[i]);
    }

    /* bubble sort the array */
    for (x=0; x < MAX-1; x++)
        for (y=0; y < MAX-x-1; y++)
            if (a[y] > a[y+1])
            {
                t=a[y];
                a[y]=a[y+1];
                a[y+1]=t;
            }

    /* print sorted array */
    printf("--------------------\n");
    for (i=0; i < MAX; i++)
        printf("%d\n",a[i]);
}
This code fills an array with random numbers, sorts them using a bubble sort, and then displays the sorted list.
Take the bubble sort code, and use what you learned in the previous article to make a function from it. Since both the array a and the constant MAX are known globally, the function you create needs no parameters, nor does it need to return a result. However, you should use local variables for x, y, and t.
Once you have tested the function to make sure it is working, pass in the number of elements as a parameter rather than using MAX:
#include <stdio.h>

#define MAX 10

int a[MAX];
int rand_seed=10;

/* from K&R
   - returns random number between 0 and 32767.*/
int rand()
{
    rand_seed = rand_seed * 1103515245 +12345;
    return (unsigned int)(rand_seed / 65536) % 32768;
}

void bubble_sort(int m)
{
    int x,y,t;
     for (x=0; x < m-1; x++)
        for (y=0; y < m-x-1; y++)
            if (a[y] > a[y+1])
            {
                t=a[y];
                a[y]=a[y+1];
                a[y+1]=t;
            }
}

void main()
{
    int i,t,x,y;
    /* fill array */
    for (i=0; i < MAX; i++)
    {
        a[i]=rand();
        printf("%d\n",a[i]);
    }
    bubble_sort(MAX);
    /* print sorted array */
    printf("--------------------\n");
    for (i=0; i < MAX; i++)
        printf("%d\n",a[i]);
}
You can also generalize the bubble_sort function even more by passing in a as a parameter:
bubble_sort(int m, int a[])
This line says, "Accept the integer array a of any size as a parameter." Nothing in the body of the bubble_sort function needs to change. To call bubble_sort, change the call to:
bubble_sort(MAX, a);
Note that &a has not been used in the function call even though the sort will change a. The reason for this will become clear once you understand pointers.



Making a Library
Since the rand and bubble_sort functions in the previous program are useful, you will probably want to reuse them in other programs you write. You can put them into a utility library to make their reuse easier.
Every library consists of two parts: a header file and the actual code file. The header file, normally denoted by a .h suffix, contains information about the library that programs using it need to know. In general, the header file contains constants and types, along with prototypes for functions available in the library. Enter the following header file and save it to a file named util.h.
/* util.h */
extern int rand();
extern void bubble_sort(int, int []);
These two lines are function prototypes. The word "extern" in C represents functions that will be linked in later. If you are using an old-style compiler, remove the parameters from the parameter list of bubble_sort.
Enter the following code into a file named util.c.
/* util.c */
#include "util.h"

int rand_seed=10;

/* from K&R
 - produces a random number between 0 and 32767.*/
int rand()
{
    rand_seed = rand_seed * 1103515245 +12345;
    return (unsigned int)(rand_seed / 65536) % 32768;
}

void bubble_sort(int m,int a[])
{
    int x,y,t;
     for (x=0; x < m-1; x++)
        for (y=0; y < m-x-1; y++)
            if (a[y] > a[y+1])
            {
                t=a[y];
                a[y]=a[y+1];
                a[y+1]=t;
            }
}

Note that the file includes its own header file (util.h) and that it uses quotes instead of the symbols < and> , which are used only for system libraries. As you can see, this looks like normal C code. Note that the variable rand_seed, because it is not in the header file, cannot be seen or modified by a program using this library. This is called information hiding. Adding the word static in front of int enforces the hiding completely.
Enter the following main program in a file named main.c.
#include <stdio.h>
#include "util.h"

#define MAX 10

int a[MAX];

void main()
{
    int i,t,x,y;
    /* fill array */
    for (i=0; i < MAX; i++)
    {
        a[i]=rand();
        printf("%d\n",a[i]);
    }

    bubble_sort(MAX,a);

    /* print sorted array */
    printf("--------------------\n");
    for (i=0; i < MAX; i++)
        printf("%d\n",a[i]);
}
This code includes the utility library. The main benefit of using a library is that the code in the main program is much shorter.
Compiling and Running with a Library
To compile the library, type the following at the command line (assuming you are using UNIX) (replace gcc with cc if your system uses cc):
gcc -c -g util.c
The -c causes the compiler to produce an object file for the library. The object file contains the library's machine code. It cannot be executed until it is linked to a program file that contains a main function. The machine code resides in a separate file named util.o.
To compile the main program, type the following:
gcc -c -g main.c
This line creates a file named main.o that contains the machine code for the main program. To create the final executable that contains the machine code for the entire program, link the two object files by typing the following:
gcc -o main main.o util.o
This links main.o and util.o to form an executable named main. To run it, type main.
Makefiles make working with libraries a bit easier. You'll find out about makefiles on the next page.