###Text Files

Text files in C are straightforward and easy to understand. All text file functions and types in C come from the **stdio** library.

When you need text I/O in a C program, and you need only one source for input information and one sink for output information, you can rely on **stdin** (standard in) and **stdout** (standard out). You can then use input and output redirection at the command line to move different information streams through the program. There are six different I/O commands in <stdio.h> that you can use with stdin and stdout:

* **printf** - prints formatted output to stdout
* **scanf** - reads formatted input from stdin
* **puts** - prints a string to stdout
* **gets** - reads a string from stdin
* **putc** - prints a character to stdout
* **getc**, **getchar** - reads a character from stdin

The advantage of stdin and stdout is that they are easy to use. Likewise, the ability to redirect I/O is very powerful. For example, maybe you want to create a program that reads from stdin and counts the number of characters:

```
#include <stdio.h>
#include <string.h>

void main()
{
    char s[1000];
    int count=0;
     while (gets(s))
        count += strlen(s);
    printf("%d\n",count);
}
```

Enter this code and run it. It waits for input from stdin, so type a few lines. When you are done, press CTRL-D to signal end-of-file (eof). The gets function reads a line until it detects eof, then returns a 0 so that the while loop ends. When you press CTRL-D, you see a count of the number of characters in stdout (the screen). (Use **man gets** or your compiler's documentation to learn more about the gets function.)

Now, suppose you want to count the characters in a file. If you compiled the program to an executable named **xxx**, you can type the following:

```
xxx < filename
```
Instead of accepting input from the keyboard, the contents of the file named **filename** will be used instead. You can achieve the same result using **pipes**:

```
cat < filename | xxx
```
You can also redirect the output to a file:

```
xxx < filename > out
```
This command places the character count produced by the program in a text file named **out**.

Sometimes, you need to use a text file directly. For example, you might need to open a specific file and read from or write to it. You might want to manage several streams of input or output or create a program like a text editor that can save and recall data or configuration files on command. In that case, use the text file functions in stdio:

* **fopen** - opens a text file
* **fclose** - closes a text file
* **feof** - detects end-of-file marker in a file
* **fprintf** - prints formatted output to a file
* **fscanf** - reads formatted input from a file
* **fputs** - prints a string to a file
* **fgets** - reads a string from a file
* **fputc** - prints a character to a file
* **fgetc** - reads a character from a file



> **MAIN FUNCTION RETURN VALUES**
> 
> *This program is the first program in this series that returns an error value from the main program. If the **fopen** command fails, f will contain a NULL value (a zero). We test for that error with the if statement. The if statement looks at the True/False value of the variable **f**. Remember that in C, 0 is False and anything else is true. So if there were an error opening the file, f would contain zero, which is False. The ! is the NOT operator. It inverts a Boolean value. So the if statement could have been written like this:*
> 
> *That is equivalent. However, **if (!f)** is more common.
If there is a file error, we return a 1 from the main function. In UNIX, you can actually test for this value on the command line. See the shell documentation for details.*


###Text Files: Opening
You use **fopen** to open a file. It opens a file for a specified mode (the three most common are r, w, and a, for read, write, and append). It then returns a file pointer that you use to access the file. For example, suppose you want to open a file and write the numbers 1 to 10 in it. You could use the following code:

```
#include <stdio.h>
#define MAX 10

int main()
{
    FILE *f;
    int x;
    f=fopen("out","w");
    if (!f)
        return 1;
    for(x=1; x<=MAX; x++)
        fprintf(f,"%d\n",x);
    fclose(f);
    return 0;
}
```

The **fopen** statement here opens a file named **out** with the w mode. This is a destructive write mode, which means that if **out** does not exist it is created, but if it does exist it is destroyed and a new file is created in its place. The fopen command returns a pointer to the file, which is stored in the variable f. This variable is used to refer to the file. If the file cannot be opened for some reason, f will contain NULL.

The fprintf statement should look very familiar: It is just like printf but uses the file pointer as its first parameter. The fclose statement closes the file when you are done.


> **C ERRORS TO AVOID**
> 
> *Do not accidentally type **close** instead of **fclose**. The close function exists, so the compiler accepts it. It will even appear to work if the program only opens or closes a few files. However, if the program opens and closes a file in a loop, it will eventually run out of available file handles and/or memory space and crash, because **close** is not closing the files correctly.*


###Text Files: Reading
To read a file, open it with r mode. In general, it is not a good idea to use **fscanf** for reading: Unless the file is perfectly formatted, fscanf will not handle it correctly. Instead, use **fgets** to read in each line and then parse out the pieces you need.
The following code demonstrates the process of reading a file and dumping its contents to the screen:

```
#include <stdio.h>

int main()
{
    FILE *f;
    char s[1000];

    f=fopen("infile","r");
    if (!f)
        return 1;
    while (fgets(s,1000,f)!=NULL)
        printf("%s",s);
    fclose(f);
    return 0;
}
```

The fgets statement returns a NULL value at the end-of-file marker. It reads a line (up to 1,000 characters in this case) and then prints it to stdout. Notice that the printf statement does not include \n in the format string, because fgets adds \n to the end of each line it reads. Thus, you can tell if a line is not complete in the event that it overflows the maximum line length specified in the second parameter to fgets.