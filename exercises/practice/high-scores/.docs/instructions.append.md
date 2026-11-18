<!-- markdownlint-disable MD013 -->
# Dummy header

## Bash Interface

Your script will be executed with an operation subcommand as the first argument, followed by the list of game scores as subsequent arguments:

```bash
high_scores.sh <operation> [scores...]
```

### Operations

- `scores`: Output all scores in their original order.
- `latest`: Output the last added score.
- `personalBest`: Output the highest score from the list.
- `personalTopThree`: Output up to three highest scores in descending order (highest to lowest). If fewer than three scores exist, output all scores ordered from highest to lowest.

### Output Format

- For single-value outputs (`latest`, `personalBest`), print the numeric value on standard output.
- For list outputs (`scores`, `personalTopThree`), print the numbers separated by a single space on standard output.

### Examples

```bash
$ high_scores.sh scores 30 50 20 70
30 50 20 70

$ high_scores.sh latest 100 0 90 30
30

$ high_scores.sh personalBest 40 100 70
100

$ high_scores.sh personalTopThree 10 30 90 30 100 20 10 0 30 40 40 70 70
100 90 70
```
