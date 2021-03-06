#!/bin/bash
#set -x
source $(dirname $0)/ape.bash

function usage() {
    echo Usage: $0 [-d PATH] LANGCODE FILE
    echo
    echo Options:
    echo    -d PATH   use PATH to find modes
    echo
    echo LANGCODE is apertium monolingual definition, typically ISO-639-3 code
    echo FILE should be text/plain or text-with-metadata container¹
    echo "¹ <https://github.com/flammie/bash-corpora#text-container-files>"
    echo
}
DSWITCH="-d ."
while test $# -gt 0 ; do
    case $1 in
        -d)
            DSWITCH="$1 $2";
            shift 2;;
        *)
            if test -z "$LL" ; then
                LL=$1;
            else
                INFILE=$1;
            fi;
            shift;;
    esac
done
if test -z "$LL" ; then
    usage
    exit 1
fi
if test -z "${INFILE}" ; then
    usage
    exit 1
fi
if ! test -r "$INFILE" ; then
    echo "Cannot open $INFILE for reading"
    exit 1
fi
CLEANED=$(mktemp -t ape-analyse.XXXXXXXXXX )
egrep -v '^#!' ${INFILE} > ${CLEANED}
echo scan for OOVs?
select a in yes no ; do
    if test "x$DSWITCH" = "x-d ." ; then
        ape_remake
    fi
    if test x$a = xno ; then
        break
    elif ! apertium ${DSWITCH} ${LL}-morph < ${CLEANED} |\
            fgrep --colour=always '*' ; then
        echo alles klar!
    fi
    apertium ${DSWITCH} ${LL}-morph < ${CLEANED} |\
        egrep -o '[*][^$]*' |\
        sort |\
        uniq
    echo "retry? (1=yes 2=no)"
done
rm -v ${CLEANED}
