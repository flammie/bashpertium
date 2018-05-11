#!/bin/bash
#set -x
function usage() {
    echo Usage: $0 [-d PATH] LANGUAGE-OR-PAIR [FILE]
    echo
    echo Options:
    echo    -d PATH   use PATH to find modes
    echo
    echo LANGUAGE-OR-PAIR is an apertium language spec definition, e.g. qzr or
    echo    qzr-qaa
    echo FILE should be formatted like uniq -c output.
    echo If FILE is not given stdin will be read.
    echo
}
DSWITCH=""
while test $# -gt 0 ; do
    case $1 in
        -d)
            DSWITCH="$1 $2";
            shift 2;;
        *)
            if test -z "$LANGSPEC" ; then
                LANGSPEC=$1;
            else
                INFILE=$1;
            fi;
            shift;;
    esac
done

case $LANGSPEC in
    *-*)
cat $INFILE |\
    apertium -f line $DSWITCH $LANGSPEC-debug |\
    sed -e 's/^ *//' -e 's/ *$//' |\
    tr ' ' '\t' |\
    awk -F '\t' '
BEGIN {ATS=0;STARS=0;HASH=0;ALL=0}
$2 ~ /^[@]/ {ATS+=$1;}
$2 ~ /^[*]/ {STARS+=$1;}
$2 ~ /^[#]/ {HASH+=$1;}
{ALL+=$1;}
END {
    printf("* %f %% (%d / %d)\n", 100*STARS/ALL, STARS, ALL);
    printf("@ %f %% (%d / %d)\n", 100*ATS/ALL, ATS, ALL);
    printf("# %f %% (%d / %d)\n", 100*HASH/ALL, HASH, ALL);
}';;
    *)
cat $INFILE |\
    apertium -f line $DSWITCH $LANGSPEC-morph |\
    sed -e 's/^ *//' -e 's/ *$//' |\
    tr '/' '\t' | sed -e 's/^ *\^//' -e 's/\$ *//' |\
    awk -F '\t' '
BEGIN {COV=0;UNK=0;}
$2 ~ /^[*]/ {STARS+=$1;}
{ALL+=$1;}
END {
    printf("* %f %% (%d / %d)\n", 100*STARS/ALL, STARS, ALL);
}';;
esac
