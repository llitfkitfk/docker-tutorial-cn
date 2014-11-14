###Branching and Looping

![](https://github.com/llitfkitfk/docker-tutorial-cn/blob/master/ref/c-if.gif)

In C, both **if** statements and **while** loops rely on the idea of **Boolean expressions**. Here is a simple C program demonstrating an if statement:

```
#include int main() { int b; printf("Enter a value:"); scanf("%d", &b); if (b < 0) printf("The value is negativen"); return 0; }
```
This program accepts a number from the user. It then tests the number using an if statement to see if it is less than 0. If it is, the program prints a message. Otherwise, the program is silent. The **(b < 0)** portion of the program is the Boolean expression. C evaluates this expression to decide whether or not to print the message. If the Boolean expression evaluates to **True**, then C executes the single line immediately following the if statement (or a block of lines within braces immediately following the if statement). If the Boolean expression is **False**, then C skips the line or block of lines immediately following the if statement.

Here's slightly more complex example:

```
#include <stdio.h>

int main()
{
    int b;
    printf("Enter a value:");
    scanf("%d", &b);
    if (b < 0)
        printf("The value is negative\n");
    return 0;
}
```

In this example, the **else if** and **else** sections evaluate for zero and positive values as well.

Here is a more complicated Boolean expression:

```
if ((x==y) && (j>k))
    z=1;
else
    q=10;
```

This statement says, "If the value in variable x equals the value in variable y, and if the value in variable j is greater than the value in variable k, then set the variable z to 1, otherwise set the variable q to 10." You will use if statements like this throughout your C programs to make decisions. In general, most of the decisions you make will be simple ones like the first example; but on occasion, things get more complicated.

Notice that C uses == to **test for equality**, while it uses = to **assign a value** to a variable. The **&&** in C represents a Boolean AND operation.

Here are all of the Boolean operators in C:

```
equality		==
less than		<
Greater than	>
<=				<=
>=				>=
inequality		!=
and				&&
or				|| 
not				!
```

You'll find that **while** statements are just as easy to use as if statements. For example:

```
while (a < b)
{
    printf("%d\n", a);
    a = a + 1;
}
```

This causes the two lines within the braces to be executed repeatedly until **a** is greater than or equal to **b**. The while statement in general works as illustrated to the right.

C also provides a **do-while** structure:

```
#include <stdio.h>

int main()
{
    int a;

    printf("Enter a number:");
    scanf("%d", &a);
    if (a)
    {
        printf("The value is True\n");
    }
    return 0;
}
```

The **for loop** in C is simply a shorthand way of expressing a while statement. For example, suppose you have the following code in C:

```
x=1;
while (x<10)
{
    blah blah blah
    x++; /* x++ is the same as saying x=x+1 */
}
```

You can convert this into a for loop as follows:

```
for(x=1; x<10; x++)
{
    blah blah blah
}
```

Note that the while loop contains an initialization step (**x=1**), a test step (**x<10**), and an increment step (**x++**). The for loop lets you put all three parts onto one line, but you can put anything into those three parts. For example, suppose you have the following loop:

```
a=1;
b=6;
while (a < b)
{
    a++;
    printf("%d\n",a);
}
```

You can place this into a for statement as well:

```
for (a=1,b=6; a < b; a++,printf("%d\n",a));
```

It is slightly confusing, but it is possible. The **comma operator** lets you separate several different statements in the initialization and increment sections of the for loop (but not in the test section). Many C programmers like to pack a lot of information into a single line of C code; but a lot of people think it makes the code harder to understand, so they break it up.


> **= VS. == IN BOOLEAN EXPRESSIONS**
> 
> *The == sign is a problem in C because every now and then you may forget and type just = in a Boolean expression. This is an easy mistake to make, but to the compiler there is a very important difference. C will accept either = and == in a Boolean expression -- the behavior of the program changes remarkably between the two, however.
Boolean expressions evaluate to integers in C, and integers can be used inside of Boolean expressions. The integer value 0 in C is False, while any other integer value is True. The following is legal in C:
If a is anything other than 0, the printf statement gets executed.
In C, a statement like if (a=b) means, "Assign b to a, and then test a for its Boolean value." So if a becomes 0, the if statement is False; otherwise, it is True. The value of a changes in the process. This is not the intended behavior if you meant to type == (although this feature is useful when used correctly), so be careful with your = and == usage.*


###Looping: A Real Example

Let's say that you would like to create a program that prints a Fahrenheit-to-Celsius conversion table. This is easily accomplished with a for loop or a while loop:

```
#include <stdio.h>

int main()
{
    int a;
    a = 0;
    while (a <= 100)
    {
        printf("%4d degrees F = %4d degrees C\n",
            a, (a - 32) * 5 / 9);
        a = a + 10;
    }
    return 0;
}
```

If you run this program, it will produce a table of values starting at 0 degrees F and ending at 100 degrees F. The output will look like this:

```
0 degrees F =  -17 degrees C
10 degrees F =  -12 degrees C
20 degrees F =   -6 degrees C
30 degrees F =   -1 degrees C
40 degrees F =    4 degrees C 
50 degrees F =   10 degrees C
60 degrees F =   15 degrees C
70 degrees F =   21 degrees C
80 degrees F =   26 degrees C
90 degrees F =   32 degrees C
100 degrees F =   37 degrees C
```
 
The table's values are in increments of 10 degrees. You can see that you can easily change the starting, ending or increment values of the table that the program produces.

If you wanted your values to be more accurate, you could use **floating point** values instead:

```
#include <stdio.h>

int main()
{
    float a;
    a = 0;
    while (a <= 100)
    {
        printf("%6.2f degrees F = %6.2f degrees C\n",
            a, (a - 32.0) * 5.0 / 9.0);
        a = a + 10;
    }
    return 0;
}
```
You can see that the declaration for **a** has been changed to a float, and the **%f** symbol replaces the **%d** symbol in the printf statement. In addition, the %f symbol has some formatting applied to it: The value will be printed with six digits preceding the decimal point and two digits following the decimal point.

Now let's say that we wanted to modify the program so that the temperature 98.6 is inserted in the table at the proper position. That is, we want the table to increment every 10 degrees, but we also want the table to include an extra line for 98.6 degrees F because that is the normal body temperature for a human being. The following program accomplishes the goal:


```
#include <stdio.h>

int main()
{
    float a;
    a = 0;
    while (a <= 100)
    {
	if (a > 98.6)
        {
            printf("%6.2f degrees F = %6.2f degrees C\n",
                98.6, (98.6 - 32.0) * 5.0 / 9.0);
        }
        printf("%6.2f degrees F = %6.2f degrees C\n",
            a, (a - 32.0) * 5.0 / 9.0);
        a = a + 10;
    }
    return 0;
}
```
This program works if the ending value is 100, but if you change the ending value to 200 you will find that the program has a **bug**. It prints the line for 98.6 degrees too many times. We can fix that problem in several different ways. Here is one way:

```
#include <stdio.h>

int main()
{
    float a, b;
    a = 0;
    b = -1;
    while (a <= 100)
    {
	if ((a > 98.6) && (b < 98.6))
        {
            printf("%6.2f degrees F = %6.2f degrees C\n",
                98.6, (98.6 - 32.0) * 5.0 / 9.0);
        }
        printf("%6.2f degrees F = %6.2f degrees C\n",
            a, (a - 32.0) * 5.0 / 9.0);
        b = a;
        a = a + 10;
    }
    return 0;
}
```

####C Errors to Avoid

* Putting = when you mean == in an if or while statement
* Forgetting to increment the counter inside the while loop - If you forget to increment the counter, you get an infinite loop (the loop never ends).
* Accidentally putting a ; at the end of a for loop or if statement so that the statement has no effect - For example: for (x=1; x<10; x++); printf("%d\n",x); only prints out one value because the semicolon after the for statement acts as the one line the for loop executes.

> **TRY THIS!**
> 
> *Try changing the Fahrenheit-to-Celsius program so that it uses scanf to accept the starting, ending and increment value for the table from the user.
Add a heading line to the table that is produced.
Try to find a different solution to the bug fixed by the previous example.
Create a table that converts pounds to kilograms or miles to kilometers.*


| PREVIOURS	| TOP | NEXT
| :------: | :-------: | :------:
| [上一篇](https://github.com/llitfkitfk/docker-tutorial-cn/blob/master/CTutorial.md)  | [带我飞](https://github.com/llitfkitfk/docker-tutorial-cn/blob/master/cTutorial/cTutorial_Looping.md#branching-and-looping)| [下一篇](https://github.com/llitfkitfk/docker-tutorial-cn/blob/master/cTutorial/cTutorial_Looping.md)