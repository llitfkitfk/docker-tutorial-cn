Functions
Most languages allow you to create functions of some sort. Functions let you chop up a long program into named sections so that the sections can be reused throughout the program. Functions accept parameters and return a result. C functions can accept an unlimited number of parameters. In general, C does not care in what order you put your functions in the program, so long as a the function name is known to the compiler before it is called.
We have already talked a little about functions. The rand function seen previously is about as simple as a function can get. It accepts no parameters and returns an integer result:
int rand()
/* from K&R
   - produces a random number between 0 and 32767.*/
{
    rand_seed = rand_seed * 1103515245 +12345;
    return (unsigned int)(rand_seed / 65536) % 32768;
}
The int rand() line declares the function rand to the rest of the program and specifies that rand will accept no parameters and return an integer result. This function has no local variables, but if it needed locals, they would go right below the opening { (C allows you to declare variables after any { -- they exist until the program reaches the matching } and then they disappear. A function's local variables therefore vanish as soon as the matching } is reached in the function. While they exist, local variables live on the system stack.) Note that there is no ; after the () in the first line. If you accidentally put one in, you will get a huge cascade of error messages from the compiler that make no sense. Also note that even though there are no parameters, you must use the (). They tell the compiler that you are declaring a function rather than simply declaring an int.
The return statement is important to any function that returns a result. It specifies the value that the function will return and causes the function to exit immediately. This means that you can place multiple return statements in the function to give it multiple exit points. If you do not place a return statement in a function, the function returns when it reaches } and returns a random value (many compilers will warn you if you fail to return a specific value). In C, a function can return values of any type: int, float, char, struct, etc.
There are several correct ways to call the rand function. For example: x=rand();. The variable x is assigned the value returned by rand in this statement. Note that you must use () in the function call, even though no parameter is passed. Otherwise, x is given the memory address of the rand function, which is generally not what you intended.
You might also call rand this way:
if (rand() > 100)
Or this way:
rand();
In the latter case, the function is called but the value returned by rand is discarded. You may never want to do this with rand, but many functions return some kind of error code through the function name, and if you are not concerned with the error code (for example, because you know that an error is impossible) you can discard it in this way.
Functions can use a void return type if you intend to return nothing. For example:
void print_header()
{
    printf("Program Number 1\n");
    printf("by Marshall Brain\n");
    printf("Version 1.0, released 12/26/91\n");
}
This function returns no value. You can call it with the following statement:
print_header();
You must include () in the call. If you do not, the function is not called, even though it will compile correctly on many systems.
C functions can accept parameters of any type. For example:
int fact(int i)
{
    int j,k;

    j=1;
    for (k=2; k<=i; k++)
        j=j*k;
    return j;
}
returns the factorial of i, which is passed in as an integer parameter. Separate multiple parameters with commas:
int add (int i, int j)
{
    return i+j;
}
C has evolved over the years. You will sometimes see functions such as add written in the "old style," as shown below:
int add(i,j)
    int i;
    int j;
{
    return i+j;
}
It is important to be able to read code written in the older style. There is no difference in the way it executes; it is just a different notation. You should use the "new style," (known as ANSI C) with the type declared as part of the parameter list, unless you know you will be shipping the code to someone who has access only to an "old style" (non-ANSI) compiler.


TRY THIS!
Go back to the bubble sort example presented earlier and create a function for the bubble sort.
Go back to earlier programs and create a function to get input from the user rather than taking the input in the main function.


Functions: Function Prototypes
It is now considered good form to use function prototypes for all functions in your program. A prototype declares the function name, its parameters, and its return type to the rest of the program prior to the function's actual declaration. To understand why function prototypes are useful, enter the following code and run it:
#include <stdio.h>

void main()
{
    printf("%d\n",add(3));
}

int add(int i, int j)
{
    return i+j;
}
This code compiles on many compilers without giving you a warning, even though add expects two parameters but receives only one. It works because many C compilers do not check for parameter matching either in type or count. You can waste an enormous amount of time debugging code in which you are simply passing one too many or too few parameters by mistake. The above code compiles properly, but it produces the wrong answer.
To solve this problem, C lets you place function prototypes at the beginning of (actually, anywhere in) a program. If you do so, C checks the types and counts of all parameter lists. Try compiling the following:
#include <stdio.h>

int add (int,int); /* function prototype for add */

void main()
{
    printf("%d\n",add(3));
}

int add(int i, int j)
{
    return i+j;
}
The prototype causes the compiler to flag an error on the printf statement.
Place one prototype for each function at the beginning of your program. They can save you a great deal of debugging time, and they also solve the problem you get when you compile with functions that you use before they are declared. For example, the following code will not compile:
#include <stdio.h>

void main()
{
    printf("%d\n",add(3));
}

float add(int i, int j)
{
    return i+j;
}
Why, you might ask, will it compile when add returns an int but not when it returns a float? Because older C compilers default to an int return value. Using a prototype will solve this problem. "Old style" (non-ANSI) compilers allow prototypes, but the parameter list for the prototype must be empty. Old style compilers do no error checking on parameter lists.