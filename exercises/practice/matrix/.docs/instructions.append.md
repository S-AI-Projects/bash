# Instructions append

## How to run the program

The program takes three arguments:

1. the matrix, as one string with a newline between the rows and spaces
   between the numbers,
2. the property to extract, either `row` or `column`,
3. the index of that row or column, counting from 1.

It prints the numbers of that row or column on one line, separated by spaces.

For this matrix:

```text
9 8 7
5 3 2
6 6 7
```

the program is run like this:

```bash
$ bash matrix.sh $'9 8 7\n5 3 2\n6 6 7' row 2
5 3 2
$ bash matrix.sh $'9 8 7\n5 3 2\n6 6 7' column 1
9 5 6
```

The `$'...'` is [ANSI-C quoting][ansi-c]: the `\n` inside it is turned into a
real newline before your program sees the string.

[ansi-c]: https://www.gnu.org/software/bash/manual/bash.html\#ANSI_002dC-Quoting
