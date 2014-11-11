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