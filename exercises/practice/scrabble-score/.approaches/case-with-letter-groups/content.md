# Case Statement with Letter Groups

```bash
word=${1^^}
score=0

for (( i = 0; i < ${#word}; i++ )); do
    letter=${word:i:1}
    case "$letter" in
        [AEIOULNRST]) (( score += 1 )) ;;
        [DG])         (( score += 2 )) ;;
        [BCMP])       (( score += 3 )) ;;
        [FHVWY])      (( score += 4 )) ;;
        [K])          (( score += 5 )) ;;
        [JX])         (( score += 8 )) ;;
        [QZ])         (( score += 10 )) ;;
    esac
done

echo "$score"
```

## How it works

1. **Character sets**: Rather than mapping each letter individually, letters that share the same point value are grouped inside bracket character sets:
   - `[AEIOULNRST]` awards 1 point.
   - `[DG]` awards 2 points.
   - `[BCMP]` awards 3 points.
   - `[FHVWY]` awards 4 points.
   - `[K]` awards 5 points.
   - `[JX]` awards 8 points.
   - `[QZ]` awards 10 points.
2. **Fast matching**: In Bash, `case` pattern matching against character brackets is evaluated directly by the shell parser without external forks or array table overhead.
