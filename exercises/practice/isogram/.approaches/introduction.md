# Introduction

There are two idiomatic approaches to solving Isogram.
You can loop over the letters of the phrase and remember the ones you have already seen.
Or you can hand the work to external tools that find repeated letters for you.

## General guidance

Whichever approach you choose, you need to take care of two things:

- **Case does not matter.**
  `Alphabet` is not an isogram because `A` and `a` are the same letter.
  Convert the phrase to lowercase first.
- **Only letters count.**
  Spaces and hyphens may appear any number of times: `six-year-old` is an isogram.
  Ignore everything that is not a letter.

## Approach: Lowercase and loop

```bash
phrase=${1,,}
for (( i = 0; i < ${#phrase}; i++ )); do
    char=${phrase:i:1}
    [[ $char == [[:lower:]] ]] || continue
    [[ $seen == *"$char"* ]] && { echo false; exit; }
    seen+=$char
done
echo true
```

Lowercase the phrase with `${1,,}`, then look at one character at a time.
Skip characters that are not lowercase letters.
If the letter is already in the string of letters seen so far, the phrase is not an isogram.
Otherwise, add it to that string and move on.

For more information, check the [Lowercase and loop approach][approach-lowercase-and-loop].

## Approach: tr, sort and uniq

```bash
repeated=$(
    tr -cd '[:alpha:]' <<< "${1,,}" |
    fold -w1 |
    sort |
    uniq -d
)
[[ -z $repeated ]] && echo true || echo false
```

Bash is naturally a "glue" language, so a pipeline of small tools is a natural fit.
`tr` keeps only the letters, `fold` puts each letter on its own line, `sort` brings equal letters next to each other, and `uniq -d` prints only the lines that appear more than once.
If the pipeline prints nothing, no letter is repeated and the phrase is an isogram.

For more information, check the [tr, sort and uniq approach][approach-tr-sort-uniq].

## Which approach to use?

- The loop uses only Bash builtins, so it does not start any other processes.
  It stops at the first repeated letter, and it is the better choice for short phrases like the ones in the tests.
- The pipeline is short and declarative, and it does not need a loop or a variable that grows.
  It starts several processes (`tr`, `fold`, `sort` and `uniq`) every time it runs, and it always looks at the whole phrase.
- For this exercise, both are fast enough, so choose the one you find easier to read.

[approach-lowercase-and-loop]: https://exercism.org/tracks/bash/exercises/isogram/approaches/lowercase-and-loop
[approach-tr-sort-uniq]: https://exercism.org/tracks/bash/exercises/isogram/approaches/tr-sort-uniq
