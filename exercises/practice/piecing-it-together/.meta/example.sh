#!/usr/bin/env bash
#
# Piecing It Together
# Deduce missing jigsaw puzzle attributes from partial data or report errors.

set -o errexit
set -o nounset

declare -A input
for arg in "$@"; do
    key="${arg%%=*}"
    val="${arg#*=}"
    input["$key"]="$val"
done

awk -v pieces="${input[pieces]:-}" \
    -v border="${input[border]:-}" \
    -v inside="${input[inside]:-}" \
    -v rows="${input[rows]:-}" \
    -v columns="${input[columns]:-}" \
    -v aspectRatio="${input[aspectRatio]:-}" \
    -v format="${input[format]:-}" '
function abs(x) { return x < 0 ? -x : x }
function is_int(x) { return abs(x - int(x + 0.5)) < 1e-6 }
function round_int(x) { return int(x + 0.5) }

function format_aspect(a, s) {
    s = sprintf("%.6g", a)
    if (s !~ /\./) s = s ".0"
    return s
}

function error_contradiction(msg) {
    print "Contradictory data" > "/dev/stderr"
    exit 1
}

function error_insufficient(msg) {
    print "Insufficient data" > "/dev/stderr"
    exit 1
}

BEGIN {
    R = -1
    C = -1

    # Case: rows and columns given
    if (rows != "" && columns != "") {
        R = rows + 0
        C = columns + 0
    }
    # Case: rows and format="square"
    else if (rows != "" && format == "square") {
        R = rows + 0
        C = R
    }
    # Case: columns and format="square"
    else if (columns != "" && format == "square") {
        C = columns + 0
        R = C
    }
    # Case: inside and aspectRatio
    else if (inside != "" && aspectRatio != "") {
        A = aspectRatio + 0
        I = inside + 0
        if (A == 1.0) {
            sq = sqrt(I)
            if (!is_int(sq)) error_contradiction("inside not square")
            R = round_int(sq) + 2
            C = R
        } else {
            error_insufficient("not implemented")
        }
    }
    # Case: pieces and aspectRatio
    else if (pieces != "" && aspectRatio != "") {
        P = pieces + 0
        A = aspectRatio + 0
        if (A <= 0 || P <= 0) error_contradiction("invalid A or P")
        r_sq = P / A
        sq = sqrt(r_sq)
        if (!is_int(sq)) error_contradiction("non-integer rows")
        R = round_int(sq)
        C = round_int(P / R)
    }
    # Case: pieces and border
    else if (pieces != "" && border != "") {
        P = pieces + 0
        B = border + 0
        S = B / 2 + 2
        disc = S * S - 4 * P
        if (disc < 0) error_contradiction("no real roots")
        sq = sqrt(disc)
        if (!is_int(sq)) error_contradiction("non-integer roots")
        d = round_int(sq)
        r1 = (S + d) / 2
        r2 = (S - d) / 2
        if (!is_int(r1) || !is_int(r2)) error_contradiction("roots not integers")
        r1 = round_int(r1)
        r2 = round_int(r2)
        if (format == "portrait") {
            R = (r1 > r2 ? r1 : r2)
            C = (r1 < r2 ? r1 : r2)
        } else if (format == "landscape") {
            R = (r1 < r2 ? r1 : r2)
            C = (r1 > r2 ? r1 : r2)
        } else if (format == "square") {
            if (r1 != r2) error_contradiction("not square")
            R = r1
            C = r2
        } else {
            error_insufficient("cannot determine orientation")
        }
    }
    else {
        error_insufficient("insufficient fields")
    }

    # Validate deduced R and C
    if (R <= 0 || C <= 0) error_contradiction("dimensions must be positive")

    P_calc = R * C
    B_calc = 2 * (R + C - 2)
    I_calc = (R - 2) * (C - 2)
    A_calc = C / R
    F_calc = (C < R) ? "portrait" : (C == R ? "square" : "landscape")

    # Verify against inputs
    if (pieces != "" && pieces + 0 != P_calc) error_contradiction("pieces mismatch")
    if (border != "" && border + 0 != B_calc) error_contradiction("border mismatch")
    if (inside != "" && inside + 0 != I_calc) error_contradiction("inside mismatch")
    if (rows != "" && rows + 0 != R) error_contradiction("rows mismatch")
    if (columns != "" && columns + 0 != C) error_contradiction("columns mismatch")
    if (format != "" && format != F_calc) error_contradiction("format mismatch")
    if (aspectRatio != "" && abs(aspectRatio + 0 - A_calc) > 1e-4) error_contradiction("aspectRatio mismatch")

    # Output JSON
    printf "{\n"
    printf "  \"pieces\": %d,\n", P_calc
    printf "  \"border\": %d,\n", B_calc
    printf "  \"inside\": %d,\n", I_calc
    printf "  \"rows\": %d,\n", R
    printf "  \"columns\": %d,\n", C
    printf "  \"aspectRatio\": %s,\n", format_aspect(A_calc)
    printf "  \"format\": \"%s\"\n", F_calc
    printf "}\n"
}
'
