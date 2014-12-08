###Command Line Arguments

C provides a fairly simple mechanism for retrieving command line parameters entered by the user. It passes an **argv** parameter to the main function in the program. **argv** structures appear in a fair number of the more advanced library calls, so understanding them is useful to any C programmer.

Enter the following code and compile it:

```
#include <stdio.h>

int main(int argc, char *argv[])
{
    int x;

    printf("%d\n",argc);
    for (x=0; x<argc; x++)
        printf("%s\n",argv[x]);
    return 0;
}
```

In this code, the main program accepts two parameters, argv and argc. The argv parameter is an array of pointers to string that contains the parameters entered when the program was invoked at the UNIX command line. The argc integer contains a count of the number of parameters. This particular piece of code types out the command line parameters. To try this, compile the code to an executable file named **aaa** and type **aaa xxx yyy zzz**. The code will print the command line parameters xxx, yyy and zzz, one per line.

The **char \*argv[]** line is an array of pointers to string. In other words, each element of the array is a pointer, and each pointer points to a string (technically, to the first character of the string). Thus, **argv[0]** points to a string that contains the first parameter on the command line (the program's name), **argv[1]** points to the next parameter, and so on. The argc variable tells you how many of the pointers in the array are valid. You will find that the preceding code does nothing more than print each of the valid strings pointed to by argv.

Because argv exists, you can let your program react to command line parameters entered by the user fairly easily. For example, you might have your program detect the word **help** as the first parameter following the program name, and dump a help file to stdout. File names can also be passed in and used in your fopen statements.