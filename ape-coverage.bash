#!/bin/bash
#set -x
function usage() {
    echo Usage: $0 [-d PATH] LANGUAGE-OR-PAIR FILE
    echo
    echo Options:
    echo    -d PATH   use PATH to find modes
    echo
    echo LANGUAGE-OR-PAIR is an apertium language spec definition, e.g. qzr or
    echo    qzr-qaa
    echo FILE should be pre-tokenised!!
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
tr -s ' ' '\n' < $INFILE | sort | uniq -c | sort -nr |\
    sed -e 's/$/ ¤¤./' |
    apertium $DSWITCH $LANGSPEC-debug |\
    sed -e 's/¤.*//' |\
    sed -e 's/^ *//' -e 's/ *$//' |\
    tr ' ' '\t' |\
    awk '
BEGIN {COV=0;UNK=0;}
/\t[*@]/ {UNK+=$1;}
/\t[^*@]/ {COV+=$1;}
END {printf("%f %% (%d / %d)\n", 100*COV/(UNK+COV), COV, UNK+COV);}';;
    *)
tr -s ' ' '\n' < $INFILE | sort | uniq -c | sort -nr |\
    sed -e 's/$/ ¤¤./' |
    apertium $DSWITCH $LANGSPEC-morph |\
    sed -e 's/¤.*//' |\
    cut -f 1,3 -d '/' |\
    tr '/' '\t' | sed -e 's/^ *\^//' -e 's/\$ *//' |\
    awk '
BEGIN {COV=0;UNK=0;}
/\t[*]/ {UNK+=$1;}
/\t[^*]/ {COV+=$1;}
END {printf("%f %% (%d / %d)\n", 100*COV/(UNK+COV), COV, UNK+COV);}';;
esac
