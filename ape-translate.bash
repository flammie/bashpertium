#!/bin/bash
#set -x
source $(dirname $0)/ape.bash

function usage() {
    echo Usage: $0 [-d PATH] TRANSLATION FILE
    echo
    echo Options:
    echo    -d PATH   use PATH to find modes
    echo
    echo TRANSLATION is apertium pair definition, e.g. qzr-qaa
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
            if test -z "$PAIR" ; then
                PAIR=$1;
            else
                INFILE=$1;
            fi;
            shift;;
    esac
done
if test -z "$PAIR" ; then
    usage
    exit 1
fi
if test -z "$INFILE" ; then
    usage
    exit 1
fi
if ! test -r "$INFILE" ; then
    echo "Cannot open $INFILE for reading"
    exit 1
fi
if test "x$DSWITCH" = "x-d ." ; then
    ape_remake
fi
CLEANED=$(mktemp -t ape-translate.XXXXXXXXXX )
egrep -v '^#!' ${INFILE} | tail -n +2 > ${CLEANED}
ANTIPAIR=${PAIR#???-}-${PAIR%-???}

echo scan for source OOVs?
select a in yes no ; do
    if test "x$DSWITCH" = "x-d ." ; then
        ape_remake
    fi
    if test x$a = xno ; then
        break;
    elif ! apertium ${DSWITCH} ${PAIR}-dgen < ${CLEANED} |\
            fgrep --colour=always '*' ; then
        break
    fi
    apertium ${DSWITCH} ${PAIR}-dgen < ${CLEANED} |\
        egrep -o '\*[^ ]*' |\
        sort |\
        uniq
    echo "once more? (1=yes 2=no)"
done
echo scan for bidix OOVs?
select a in yes no ; do
    if test "x$DSWITCH" = "x-d ." ; then
        ape_remake
    fi
    if test x$a = xno ; then
        break
    elif ! apertium ${DSWITCH} ${PAIR}-dgen < ${CLEANED} |\
            fgrep --colour=always '@' ; then
        break
    fi
    apertium ${DSWITCH} ${PAIR}-dgen < ${CLEANED} |\
        egrep -o '@[^<@*]*' |\
        tr -d '@<#' |\
        sort |\
        uniq |\
        apertium ${DSWITCH} ${PAIR}-morph |\
        egrep '[[:alnum:]]*<[[:alnum:]<>]*' --colour=always
    echo "ones more? (1=yes 2=no)"
done
echo scan for target OOVs?
select a in yes no ; do
    if test "x$DSWITCH" = "x-d ." ; then
        ape_remake
    fi
    if test x$a = xno ; then
        break
    elif ! apertium ${DSWITCH} ${PAIR}-dgen < ${CLEANED} |\
            fgrep --colour=always '#' ; then
        break
    fi
    apertium ${DSWITCH} ${PAIR}-dgen < ${CLEANED} |\
        egrep -o '#[^<]*[^ ]*' |\
        tr -d '#' |\
        sed -e 's/</	<!-- </' -e 's/$/ -->/' |\
        sort |\
        uniq |\
        apertium ${DSWITCH} -f html-noent ${ANTIPAIR}-morph |\
        egrep '[[:alnum:]]*<[[:alnum:]<>]*' --colour=always
    echo "keep going? (1=yes 2=no)"
done
apertium ${DSWITCH} ${PAIR} < ${CLEANED}
rm -v ${CLEANED}
