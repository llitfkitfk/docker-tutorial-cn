###Arrays

In this section, we will create a small C program that generates 10 random numbers and sorts them. To do that, we will use a new variable arrangement called an **array**.

![](https://github.com/llitfkitfk/docker-tutorial-cn/blob/master/ref/c-array.gif)

An array lets you declare and work with a collection of values of the same type. For example, you might want to create a collection of five integers. One way to do it would be to declare five integers directly:

```
int a, b, c, d, e;
```
This is okay, but what if you needed a thousand integers? An easier way is to declare an array of five integers:

```
int a[5];
```
The five separate integers inside this array are accessed by an index. All arrays start at **index** zero and go to n-1 in C. Thus, **int a[5]**; contains five elements. For example:

```
int a[5];

a[0] = 12;
a[1] = 9;
a[2] = 14;
a[3] = 5;
a[4] = 1;
```
One of the nice things about array indexing is that you can use a loop to manipulate the index. For example, the following code initializes all of the values in the array to 0:

```
int a[5];
int i;

for (i=0; i<5; i++)
    a[i] = 0;
```
The following code initializes the values in the array sequentially and then prints them out:

```
#include <stdio.h>

int main()
{
    int a[5];
    int i;

    for (i=0; i<5; i++)
        a[i] = i;
    for (i=0; i<5; i++)
        printf("a[%d] = %d\n", i, a[i]);
}
```

Arrays are used all the time in C. To understand a common usage, start an editor and enter the following code:

```
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

int main()
{
    int i,t,x,y;

    /* fill array */
    for (i=0; i < MAX; i++)
    {
        a[i]=rand();
        printf("%d\n",a[i]);
    }

    /* more stuff will go here in a minute */

    return 0;
}
```

This code contains several new concepts. The **#define** line declares a constant named **MAX** and sets it to 10. Constant names are traditionally written in all caps to make them obvious in the code. The line **int a[MAX]**; shows you how to declare an array of integers in C. Note that because of the position of the array's declaration, it is global to the entire program.

The line **int rand_seed=10** also declares a global variable, this time named **rand_seed**, that is initialized to 10 each time the program begins. This value is the starting seed for the random number code that follows. In a real random number generator, the seed should initialize as a random value, such as the system time. Here, the **rand** function will produce the same values each time you run the program.

The line **int rand()** is a function declaration. The rand function accepts no parameters and returns an integer value. We will learn more about functions later. The four lines that follow implement the rand function. We will ignore them for now.

The main function is normal. Four local integers are declared, and the array is filled with 10 random values using a for loop. Note that the array **a** contains 10 individual integers. You point to a specific integer in the array using square brackets. So **a[0]** refers to the first integer in the array, **a[1]** refers to the second, and so on. The line starting with **/\*** and ending with **\*/** is called a comment. The compiler completely ignores the line. You can place notes to yourself or other programmers in **comments**.
Now add the following code in place of **the more stuff** ... comment:

```
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
```
This code **sorts** the random values and prints them in sorted order. Each time you run it, you will get the same values. If you would like to change the values that are sorted, change the value of rand_seed each time you run the program.

The only easy way to truly understand what this code is doing is to execute it "by hand." That is, assume **MAX** is 4 to make it a little more manageable, take out a sheet of paper and pretend you are the computer. Draw the array on your paper and put four random, unsorted values into the array. Execute each line of the sorting section of the code and draw out exactly what happens. You will find that, each time through the inner loop, the larger values in the array are pushed toward the bottom of the array and the smaller values bubble up toward the top.


> **TRY THIS!**
>
> * *In the first piece of code, try changing the for loop that fills the array to a single line of code. Make sure that the result is the same as the original code.
* *Take the bubble sort code out and put it into its own function. The function header will be void bubble_sort(). Then move the variables used by the bubble sort to the function as well, and make them local there. Because the array is global, you do not need to pass parameters.*
* *Initialize the random number seed to different values.*

---

> **C ERRORS TO AVOID**
> 
> * *C has no range checking, so if you index past the end of the array, it will not tell you about it. It will eventually crash or give you garbage data.*
* *A function call must include () even if no parameters are passed. For example, C will accept x=rand;, but the call will not work. The memory address of the rand function will be placed into x instead. You must say x=rand();.*


###More on Arrays

####Variable Types
There are three standard variable types in C:

* **Integer: int**
* **Floating point: float**
* **Character: char**

An int is a 4-byte integer value. A float is a 4-byte floating point value. A char is a 1-byte single character (like "a" or "3"). A string is declared as an array of characters.

There are a number of derivative types:

* **double** (8-byte floating point value)
* **short** (2-byte integer)
* **unsigned short** or **unsigned int** (positive integers, no sign bit)

####Operators and Operator Precedence

The operators in C are similar to the operators in most languages:

* **+ - addition**
* **- - subtraction**
* **/ - division**
* **\* - multiplication**
* **% - mod**

The / operator performs integer division if both operands are integers, and performs floating point division otherwise. For example:

```
void main()
{
    float a;
    a=10/3;
    printf("%f\n",a);
}
```

This code prints out a floating point value since a is declared as type **float**, but a will be 3.0 because the code performed an integer division.

**Operator precedence** in C is also similar to that in most other languages. Division and multiplication occur first, then addition and subtraction. The result of the calculation 5+3*4 is 17, not 32, because the * operator has higher precedence than + in C. You can use parentheses to change the normal precedence ordering: (5+3)*4 is 32. The 5+3 is evaluated first because it is in parentheses. We'll get into precedence later -- it becomes somewhat complicated in C once pointers are introduced.

####Typecasting

C allows you to perform type conversions on the fly. You do this especially often when using pointers. Typecasting also occurs during the assignment operation for certain types. For example, in the code above, the integer value was automatically converted to a float.

You do typecasting in C by placing the type name in parentheses and putting it in front of the value you want to change. Thus, in the above code, replacing the line **a=10/3;** with **a=(float)10/3;** produces 3.33333 as the result because 10 is converted to a floating point value before the division.

####Typedef
You declare named, user-defined types in C with the **typedef** statement. The following example shows a type that appears often in C code:

```
#define TRUE  1
#define FALSE 0
typedef int boolean;

void main()
{
    boolean b;

    b=FALSE;
    blah blah blah
}
```

This code allows you to declare Boolean types in C programs.

If you do not like the word "float'' for real numbers, you can say:

```
typedef float real;
```
and then later say:

```
real r1,r2,r3;
```

You can place typedef statements anywhere in a C program as long as they come prior to their first use in the code.

####Structures
Structures in C allow you to group variable into a package. Here's an example:

```
struct rec
{
    int a,b,c;
    float d,e,f;
};

struct rec r;
```
As shown here, whenever you want to declare structures of the type **rec**, you have to say **struct rec**. This line is very easy to forget, and you get many compiler errors because you absent-mindedly leave out the **struct**. You can compress the code into the form:

```
struct rec
{
    int a,b,c;
    float d,e,f;
} r;
```
where the type declaration for **rec** and the variable **r** are declared in the same statement. Or you can create a typedef statement for the structure name. For example, if you do not like saying **struct rec r** every time you want to declare a record, you can say:

```
typedef struct rec rec_type;
```

and then declare records of type **rec_type** by saying:

```
rec_type r;
```

You access fields of structure using a period, for example, **r.a=5;**.

####Arrays
You declare arrays by inserting an array size after a normal declaration, as shown below:

```
int a[10];        /* array of integers */
char s[100];      /* array of characters
                    (a C string) */
float f[20];      /* array of reals */
struct rec r[50]; /* array of records */
```

####Incrementing

```
Long Way     Short Way
i=i+1;       i++;
i=i-1;       i--;
i=i+3;       i += 3;
i=i*j;       i *= j;
```