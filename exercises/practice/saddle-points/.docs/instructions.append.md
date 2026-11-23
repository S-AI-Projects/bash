# Instructions append

## Input and Output Format

### Input Format

The matrix is provided as command-line arguments to the script, where each argument represents a row in the matrix with space-separated integer values.

For example, a $3 \times 3$ matrix:

```text
9 8 7
5 3 2
6 6 7
```

is supplied as three separate arguments:

```bash
saddle_points.sh "9 8 7" "5 3 2" "6 6 7"
```

An empty matrix is represented by providing no arguments (or empty arguments).

### Output Format

For each identified saddle point, print a row and column coordinate pair on a new line:

```text
row <r>, column <c>
```

where `<r>` and `<c>` are the 1-indexed row and column positions respectively.

For the example matrix above:

```bash
saddle_points.sh "9 8 7" "5 3 2" "6 6 7"
```

the output is:

```text
row 2, column 1
```

If multiple saddle points exist, output each coordinate pair on its own line sorted by row ascending, then column ascending:

```text
row 1, column 2
row 2, column 2
row 3, column 2
```

If the matrix contains no saddle points, the script should produce no output and exit with status `0`.
