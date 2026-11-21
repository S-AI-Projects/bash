# Dummy header

## Input and output format

Bash has no dictionaries, so the legacy mapping is passed as command-line
arguments, one per score group, in the form `<score>:<LETTER>,<LETTER>,...`.
For example:

```sh
bash etl.sh "1:A,E" "2:D,G"
```

prints one line per letter, in the form `<letter>: <score>`, with the letter
in lower case:

```text
a: 1
d: 2
e: 1
g: 2
```

The order of the output lines does not matter.
