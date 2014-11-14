###Advanced Pointers
You will normally use pointers in somewhat more complicated ways than those shown in some of the previous examples. For example, it is much easier to create a normal integer and work with it than it is to create and use a pointer to an integer. In this section, some of the more common and advanced ways of working with pointers will be explored.
Pointer Types
It is possible, legal, and beneficial to create pointer types in C, as shown below:
typedef int *IntPointer;
...
IntPointer p;

This is the same as saying:
int *p;
This technique will be used in many of the examples on the following pages. The technique often makes a data declaration easier to read and understand, and also makes it easier to include pointers inside of structures or pass pointer parameters in functions.


###Pointers to Structures

It is possible to create a pointer to almost any type in C, including user-defined types. It is extremely common to create pointers to structures. An example is shown below:

![](https://github.com/llitfkitfk/docker-tutorial-cn/blob/master/ref/c-dds1.gif)
 
typedef struct
{
	char name[21];
	char city[21];
	char state[3];
} Rec;
typedef Rec *RecPointer;

RecPointer r;
r = (RecPointer)malloc(sizeof(Rec));
The pointer r is a pointer to a structure. Please note the fact that r is a pointer, and therefore takes four bytes of memory just like any other pointer. However, the malloc statement allocates 45 bytes of memory from the heap. *r is a structure just like any other structure of type Rec. The following code shows typical uses of the pointer variable:
strcpy((*r).name, "Leigh");
strcpy((*r).city, "Raleigh");
strcpy((*r).state, "NC");
printf("%s\n", (*r).city);
free(r);
You deal with *r just like a normal structure variable, but you have to be careful with the precedence of operators in C. If you were to leave off the parenthesis around *r the code would not compile because the "." operator has a higher precedence than the "*" operator. Because it gets tedious to type so many parentheses when working with pointers to structures, C includes a shorthand notation that does exactly the same thing:
strcpy(r->name, "Leigh");
The r-> notation is exactly equivalent to (*r)., but takes two fewer characters.


###Pointers to Arrays

![](https://github.com/llitfkitfk/docker-tutorial-cn/blob/master/ref/c-dds2.gif)

It is also possible to create pointers to arrays, as shown below:
int *p;
	int i;

	p = (int *)malloc(sizeof(int[10]));
	for (i=0; i<10; i++)
		p[i] = 0;
	free(p);
or:
	int *p;
	int i;

	p = (int *)malloc(sizeof(int[10]));
	for (i=0; i<10; i++)
		*(p+i) = 0;
	free(p);

 
Note that when you create a pointer to an integer array, you simply create a normal pointer to int. The call to malloc allocates an array of whatever size you desire, and the pointer points to that array's first element. You can either index through the array pointed to by p using normal array indexing, or you can do it using pointer arithmetic. C sees both forms as equivalent.
This particular technique is extremely useful when working with strings. It lets you allocate enough storage to exactly hold a string of a particular size.



###Arrays of Pointers

![](https://github.com/llitfkitfk/docker-tutorial-cn/blob/master/ref/c-dds3.gif)

Sometimes a great deal of space can be saved, or certain memory-intensive problems can be solved, by declaring an array of pointers. In the example code below, an array of 10 pointers to structures is declared, instead of declaring an array of structures. If an array of the structures had been created instead, 243 * 10 = 2,430 bytes would have been required for the array. Using the array of pointers allows the array to take up minimal space until the actual records are allocated with malloc statements. The code below simply allocates one record, places a value in it, and disposes of the record to demonstrate the process:
	typedef struct
	{
		char s1[81];
		char s2[81];
		char s3[81];
	} Rec;
	Rec *a[10];

	a[0] = (Rec *)malloc(sizeof(Rec));
	strcpy(a[0]->s1, "hello");
	free(a[0]);
	

###Structures Containing Pointers
Structures can contain pointers, as shown below:

![](https://github.com/llitfkitfk/docker-tutorial-cn/blob/master/ref/c-dds4.gif)

typedef struct
	{
		char name[21];
		char city[21];
		char phone[21];
		char *comment;
	} Addr;
	Addr s;
	char comm[100];

	gets(s.name, 20);
	gets(s.city, 20);
	gets(s.phone, 20);
	gets(comm, 100);
	s.comment =
     (char *)malloc(sizeof(char[strlen(comm)+1]));
	strcpy(s.comment, comm);
 
This technique is useful when only some records actually contained a comment in the comment field. If there is no comment for the record, then the comment field would consist only of a pointer (4 bytes). Those records having a comment then allocate exactly enough space to hold the comment string, based on the length of the string typed by the user.



###Pointers to Pointers

![](https://github.com/llitfkitfk/docker-tutorial-cn/blob/master/ref/c-dds5b.gif)

It is possible and often useful to create pointers to pointers. This technique is sometimes called a handle, and is useful in certain situations where the operating system wants to be able to move blocks of memory on the heap around at its discretion. The following example demonstrates a pointer to a pointer:
int **p;
	int *q;

	p = (int **)malloc(sizeof(int *));
	*p = (int *)malloc(sizeof(int));
	**p = 12;
	q = *p;
	printf("%d\n", *q);
	free(q);
	free(p);
Windows and the Mac OS use this structure to allow memory compaction on the heap. The program manages the pointer p, while the operating system manages the pointer *p. Because the OS manages *p, the block pointed to by *p (**p) can be moved, and *p can be changed to reflect the move without affecting the program using p. Pointers to pointers are also frequently used in C to handle pointer parameters in functions.




###Pointers to Structures Containing Pointers
It is also possible to create pointers to structures that contain pointers. The following example uses the Addr record from the previous section:

![](https://github.com/llitfkitfk/docker-tutorial-cn/blob/master/ref/c-dds6.gif)

typedef struct
	{
		char name[21];
		char city[21];
		char phone[21];
		char *comment;
	} Addr;
	Addr *s;
	char comm[100];

	s = (Addr *)malloc(sizeof(Addr));
	gets(s->name, 20);
	gets(s->city, 20);
	gets( s->phone, 20);
	gets(comm, 100);
	s->comment =
     (char *)malloc(sizeof(char[strlen(comm)+1]));
	strcpy(s->comment, comm);
 
The pointer s points to a structure that contains a pointer that points to a string.
In this example, it is very easy to create lost blocks if you aren't careful. For example, here is a different version of the AP example.

![](https://github.com/llitfkitfk/docker-tutorial-cn/blob/master/ref/c-dds7.gif)

s = (Addr *)malloc(sizeof(Addr));
	gets(comm, 100);
	s->comment =
     (char *)malloc(sizeof(char[strlen(comm)+1]));
	strcpy(s->comment, comm);
	free(s);
 
This code creates a lost block because the structure containing the pointer pointing to the string is disposed of before the string block is disposed of, as shown here.

####Linking
Finally, it is possible to create structures that are able to point to identical structures, and this capability can be used to link together a whole string of identical records in a structure called a linked list.
typedef struct
	{
		char name[21];
		char city[21];
		char state[21];
		Addr *next;
	} Addr;
	Addr *first;
 
The compiler will let you do this, and it can be used with a little experience to create structures like the one shown to the below.

![](https://github.com/llitfkitfk/docker-tutorial-cn/blob/master/ref/c-dds8.gif)



> TRY THIS!
> 
> Build a driver program and a makefile, and compile the stack library with the driver to make sure it works.

###A Linked Stack Example
A good example of dynamic data structures is a simple stack library, one that uses a dynamic list and includes functions to init, clear, push, and pop. The library's header file looks like this:
/* Stack Library - This library offers the
   minimal stack operations for a
   stack of integers (easily changeable) */

typedef int stack_data;

extern void stack_init();
/* Initializes this library.
   Call first before calling anything. */

extern void stack_clear();
/* Clears the stack of all entries. */

extern int stack_empty();
/* Returns 1 if the stack is empty, 0 otherwise. */

extern void stack_push(stack_data d);
/* Pushes the value d onto the stack. */

extern stack_data stack_pop();
/* Returns the top element of the stack,
   and removes that element.
   Returns garbage if the stack is empty. */
The library's code file follows:
#include "stack.h"
#include <stdio.h>

/* Stack Library - This library offers the
   minimal stack operations for a stack of integers */

struct stack_rec
{
    stack_data data;
    struct stack_rec *next;
};

struct stack_rec *top=NULL;

void stack_init()
/* Initializes this library.
   Call before calling anything else. */
{
    top=NULL;
}

void stack_clear()
/* Clears the stack of all entries. */
{
    stack_data x;

    while (!stack_empty())
    x=stack_pop();
}

int stack_empty()
/* Returns 1 if the stack is empty, 0 otherwise. */
{
    if (top==NULL)
        return(1);
    else
        return(0);
}

void stack_push(stack_data d)
/* Pushes the value d onto the stack. */
{
    struct stack_rec *temp;
    temp=
  (struct stack_rec *)malloc(sizeof(struct stack_rec));
    temp->data=d;
    temp->next=top;
    top=temp;
}

stack_data stack_pop()
/* Returns the top element of the stack,
   and removes that element.
   Returns garbage if the stack is empty. */
{
    struct stack_rec *temp;
    stack_data d=0;
    if (top!=NULL)
    {
        d=top->data;
        temp=top;
        top=top->next;
        free(temp);
    }
    return(d);
}
Note how this library practices information hiding: Someone who can see only the header file cannot tell if the stack is implemented with arrays, pointers, files, or in some other way. Note also that C uses NULL. NULL is defined in stdio.h, so you will almost always have to include stdio.h when you use pointers. NULL is the same as zero.

> C Errors to Avoid
> 
> Forgetting to include parentheses when you reference a record, as in (*p).i above
Failing to dispose of any block you allocate - For example, you should not say top=NULL in the stack function, because that action orphans blocks that need to be disposed.
Forgetting to include stdio.h with any pointer operations so that you have access to NULL.

-----

> Other Things to Try
> 
> Add a dup, a count, and an add function to the stack library to duplicate the top element of the stack, return a count of the number of elements in the stack, and add the top two elements in the stack.





###Using Pointers with Arrays
Arrays and pointers are intimately linked in C. To use arrays effectively, you have to know how to use pointers with them. Fully understanding the relationship between the two probably requires several days of study and experimentation, but it is well worth the effort.
Let's start with a simple example of arrays in C:
#define MAX 10

int main()
{
    int a[MAX];
    int b[MAX];
    int i;
    for(i=0; i<MAX; i++)
        a[i]=i;
    b=a;
    return 0;
}
Enter this code and try to compile it. You will find that C will not compile it. If you want to copy a into b, you have to enter something like the following instead:
for (i=0; i<MAX; i++)
    b[i]=a[i];

Or, to put it more succinctly:
for (i=0; i<MAX; b[i]=a[i], i++);
Better yet, use the memcpy utility in string.h.
Arrays in C are unusual in that variables a and b are not, technically, arrays themselves. Instead they are permanent pointers to arrays. a and b permanently point to the first elements of their respective arrays -- they hold the addresses of a[0] and b[0] respectively. Since they are permanent pointers you cannot change their addresses. The statement a=b; therefore does not work.
Because a and b are pointers, you can do several interesting things with pointers and arrays. For example, the following code works:
#define MAX 10

void main()
{
    int a[MAX];
    int i;
    int *p;

    p=a;
    for(i=0; i<MAX; i++)
        a[i]=i;
    printf("%d\n",*p);
}


![](https://github.com/llitfkitfk/docker-tutorial-cn/blob/master/ref/c-array-pointer.gif)

```
The state of the variables right before the for loop starts executing.
```

The statement p=a; works because a is a pointer. Technically, a points to the address of the 0th element of the actual array. This element is an integer, so a is a pointer to a single integer. Therefore, declaring p as a pointer to an integer and setting it equal to a works. Another way to say exactly the same thing would be to replace p=a; with p=&a[0];. Since a contains the address of a[0], a and &a[0] mean the same thing.
Now that p is pointing at the 0th element of a, you can do some rather strange things with it. The a variable is a permanent pointer and can not be changed, but p is not subject to such restrictions. C actually encourages you to move it around using pointer arithmetic . For example, if you say p++;, the compiler knows that p points to an integer, so this statement increments p the appropriate number of bytes to move it to the next element of the array. If p were pointing to an array of 100-byte-long structures, p++; would move p over by 100 bytes. C takes care of the details of element size.
You can copy the array a into b using pointers as well. The following code can replace (for i=0; i<MAX; a[i]=b[i], i++); :
p=a;
q=b;
for (i=0; i<MAX; i++)
{
    *q = *p;
    q++;
    p++;
}

You can abbreviate this code as follows:
p=a;
q=b;
for (i=0; i<MAX; i++)
    *q++ = *p++;
And you can further abbreviate it to:
for (p=a,q=b,i=0; i<MAX; *q++ = *p++, i++);
What if you go beyond the end of the array a or b with the pointers p or q? C does not care -- it blithely goes along incrementing p and q, copying away over other variables with abandon. You need to be careful when indexing into arrays in C, because C assumes that you know what you are doing.
You can pass an array such as a or b to a function in two different ways. Imagine a function dump that accepts an array of integers as a parameter and prints the contents of the array to stdout. There are two ways to code dump:
void dump(int a[],int nia)
{
    int i;
     for (i=0; i<nia; i++)
        printf("%d\n",a[i]);
}
or:
void dump(int *p,int nia)
{
    int i;
     for (i=0; i<nia; i++)
        printf("%d\n",*p++);
}
The nia (number_in_array) variable is required so that the size of the array is known. Note that only a pointer to the array, rather than the contents of the array, is passed to the function. Also note that C functions can accept variable-size arrays as parameters.