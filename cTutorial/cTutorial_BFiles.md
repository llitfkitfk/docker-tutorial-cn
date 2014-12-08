###Binary Files

Binary files are very similar to arrays of structures, except the structures are in a disk file rather than in an array in memory. Because the structures in a binary file are on disk, you can create very large collections of them (limited only by your available disk space). They are also permanent and always available. The only disadvantage is the slowness that comes from disk access time.

Binary files have two features that distinguish them from text files:

* You can jump instantly to any structure in the file, which provides random access as in an array.
* You can change the contents of a structure anywhere in the file at any time.

Binary files also usually have faster read and write times than text files, because a binary image of the record is stored directly from memory to disk (or vice versa). In a text file, everything has to be converted back and forth to text, and this takes time.

C supports the file-of-structures concept very cleanly. Once you open the file you can read a structure, write a structure, or seek to any structure in the file. This file concept supports the concept of a **file pointer**. When the file is opened, the pointer points to record 0 (the first record in the file). Any **read operation** reads the currently pointed-to structure and moves the pointer down one structure. Any **write operation** writes to the currently pointed-to structure and moves the pointer down one structure. **Seek** moves the pointer to the requested record.

Keep in mind that C thinks of everything in the disk file as blocks of bytes read from disk into memory or read from memory onto disk. C uses a file pointer, but it can point to any byte location in the file. You therefore have to keep track of things.

The following program illustrates these concepts:

```
#include <stdio.h>

/* random record description - could be anything */
struct rec
{
    int x,y,z;
};

/* writes and then reads 10 arbitrary records
   from the file "junk". */
int main()
{
    int i,j;
    FILE *f;
    struct rec r;

    /* create the file of 10 records */
    f=fopen("junk","w");
    if (!f)
        return 1;
    for (i=1;i<=10; i++)
    {
        r.x=i;
        fwrite(&r,sizeof(struct rec),1,f);
    }
    fclose(f);

    /* read the 10 records */
    f=fopen("junk","r");
    if (!f)
        return 1;
    for (i=1;i<=10; i++)
    {
        fread(&r,sizeof(struct rec),1,f);
        printf("%d\n",r.x);
    }
    fclose(f);
    printf("\n");

    /* use fseek to read the 10 records
       in reverse order */
    f=fopen("junk","r");
    if (!f)
        return 1;
    for (i=9; i>=0; i--)
    {
        fseek(f,sizeof(struct rec)*i,SEEK_SET);
        fread(&r,sizeof(struct rec),1,f);
        printf("%d\n",r.x);
    }
    fclose(f);
    printf("\n");

    /* use fseek to read every other record */
    f=fopen("junk","r");
    if (!f)
        return 1;
    fseek(f,0,SEEK_SET);
    for (i=0;i<5; i++)
    {
        fread(&r,sizeof(struct rec),1,f);
        printf("%d\n",r.x);
        fseek(f,sizeof(struct rec),SEEK_CUR);
    }
    fclose(f);
    printf("\n");

    /* use fseek to read 4th record,
       change it, and write it back */
    f=fopen("junk","r+");
    if (!f)
        return 1;
    fseek(f,sizeof(struct rec)*3,SEEK_SET);
    fread(&r,sizeof(struct rec),1,f);
    r.x=100;
    fseek(f,sizeof(struct rec)*3,SEEK_SET);
    fwrite(&r,sizeof(struct rec),1,f);
    fclose(f);
    printf("\n");

    /* read the 10 records to insure
       4th record was changed */
    f=fopen("junk","r");
    if (!f)
        return 1;
    for (i=1;i<=10; i++)
    {
        fread(&r,sizeof(struct rec),1,f);
        printf("%d\n",r.x);
    }
    fclose(f);
    return 0;
}
```

In this program, a structure description **rec** has been used, but you can use any structure description you want. You can see that **fopen** and **fclose** work exactly as they did for text files.

The new functions here are **fread**, **fwrite** and **fseek**. The fread function takes four parameters:

* A memory address
* The number of bytes to read per block
* The number of blocks to read
* The file variable

Thus, the line **fread(&r,sizeof(struct rec),1,f);** says to read 12 bytes (the size of rec) from the file **f** (from the current location of the file pointer) into memory address **&r**. One block of 12 bytes is requested. It would be just as easy to read 100 blocks from disk into an array in memory by changing 1 to 100.

The **fwrite** function works the same way, but moves the block of bytes from memory to the file. The **fseek** function moves the file pointer to a byte in the file. Generally, you move the pointer in **sizeof(struct rec)** increments to keep the pointer at record boundaries. You can use three options when seeking:

* SEEK_SET
* SEEK_CUR
* SEEK_END

**SEEK_SET** moves the pointer **x** bytes down from the beginning of the file (from byte 0 in the file). **SEEK_CUR** moves the pointer **x** bytes down from the current pointer position. **SEEK_END** moves the pointer from the end of the file (so you must use negative offsets with this option).

Several different options appear in the code above. In particular, note the section where the file is opened with **r+** mode. This opens the file for reading and writing, which allows records to be changed. The code seeks to a record, reads it, and changes a field; it then seeks back because the read displaced the pointer, and writes the change back.