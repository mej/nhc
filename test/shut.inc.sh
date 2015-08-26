# SHell Unit Test framework
#
# Michael Jennings <mej@lbl.gov>
# 29 June 2012
#
# $Id$
#

# This is a simple unit test framework for BASH shell scripts.  The
# interface is based on Perl's Test::More.  SHUT stands for "SHell
# Unit Testing."  I almost named it the Shell Testing Framework for
# Unix (STFU), but that seemed to make others inexplicably angry....

SHUT_SKIPPING=0
SHUT_CHECK_SKIP='if skipping ; then skip ; return 0 ; fi'
SHUT_TESTS_DONE=0
SHUT_TESTSET_NUM=0
SHUT_TESTSET_PLANNED=0
SHUT_TESTSET_DONE=0
SHUT_TESTSET_SKIPPED=0
SHUT_TESTSET_NAME=""

function pass() {
    ((SHUT_TESTS_DONE++))
    ((SHUT_TESTSET_DONE++))
    if [[ $SHUT_TESTSET_SKIPPED -gt 0 ]]; then
        echo -e "ok $SHUT_TESTSET_DONE/$SHUT_TESTSET_PLANNED ($SHUT_TESTSET_SKIPPED skipped)\r$SHUT_TESTSET_NAME...\c"
    else
        echo -e "ok $SHUT_TESTSET_DONE/$SHUT_TESTSET_PLANNED\r$SHUT_TESTSET_NAME...\c"
    fi
}

function fail() {
    ((SHUT_TESTS_DONE++))
    ((SHUT_TESTSET_DONE++))
    if [[ $SHUT_TESTSET_SKIPPED -gt 0 ]]; then
        echo "failed $SHUT_TESTSET_DONE/$SHUT_TESTSET_PLANNED ($SHUT_TESTSET_SKIPPED skipped)"
    else
        echo "failed $SHUT_TESTSET_DONE/$SHUT_TESTSET_PLANNED"
    fi
    echo "TEST FAILED:  $*" >&2
    exit -1
}

function plan() {
    ((SHUT_TESTSET_NUM++))
    SHUT_TESTSET_PLANNED=$1
    SHUT_TESTSET_NAME="${2:-Test set #$SHUT_TESTSET_NUM}"
    SHUT_TESTSET_SKIPPED=0
    SHUT_TESTSET_DONE=0
    echo -e "$SHUT_TESTSET_NAME...\c"
    return 0
}

function unplan() {
    check_plan
    SHUT_TESTSET_PLANNED=0
    SHUT_TESTSET_NAME=""
    SHUT_TESTSET_SKIPPED=0
    SHUT_TESTSET_DONE=0
}

function planned() {
    return $((! SHUT_TESTSET_PLANNED))
}

function unplanned() {
    return $SHUT_TESTSET_PLANNED
}

function check_plan() {
    if planned ; then
        if [[ $SHUT_TESTSET_PLANNED != $SHUT_TESTSET_DONE ]]; then
            fail "$SHUT_TESTSET_DONE/$SHUT_TESTSET_PLANNED tests performed."
        fi
        echo "ok"
    fi
}

function skip() {
    ((SHUT_TESTSET_SKIPPED+=${1:-1}))
    ((SHUT_TESTSET_DONE+=${1:-1}))
    ((SHUT_TESTS_DONE+=${1:-1}))
    if [[ $SHUT_TESTSET_SKIPPED -gt 0 ]]; then
        echo -e "ok $SHUT_TESTSET_DONE/$SHUT_TESTSET_PLANNED ($SHUT_TESTSET_SKIPPED skipped)\r$SHUT_TESTSET_NAME...\c"
    else
        echo -e "ok $SHUT_TESTSET_DONE/$SHUT_TESTSET_PLANNED\r$SHUT_TESTSET_NAME...\c"
    fi
    return 1
}

function skip_begin() {
    SHUT_SKIPPING=1
    return 0
}

function skip_end() {
    SHUT_SKIPPING=0
    return 0
}

function skipping() {
    return $((! SHUT_SKIPPING))
}

function ok() {
    local TEST="$1" MSG="$2"

    eval $SHUT_CHECK_SKIP
    eval "if $TEST ; then pass '$MSG' ; else fail '$MSG ($TEST) returned false.' ; fi"
    return 0
}

function cmp_ok() {
    local VAL="$1" OP="$2" EXPECTED="$3" MSG="$4"

    eval $SHUT_CHECK_SKIP
    eval "if [[ \"$VAL\" $OP \"$EXPECTED\" ]]; then pass '$MSG' ; else fail '$MSG ($VAL $OP $EXPECTED) is false.' ; fi"
}

function is() {
    local VAL="$1" EXPECTED="$2" MSG="$3"

    eval $SHUT_CHECK_SKIP
    if [[ "$VAL" == "$EXPECTED" ]]; then
        pass "$MSG"
    else
        fail "$MSG:  Got \"$VAL\" but expected \"$EXPECTED\""
    fi
}

function isnt() {
    local VAL="$1" EXPECTED="$2" MSG="$3"

    eval $SHUT_CHECK_SKIP
    if [[ "$VAL" != "$EXPECTED" ]]; then
        pass "$MSG"
    else
        fail "$MSG:  Got \"$VAL\" but expected something else"
    fi
}

function like_regexp() {
    if [[ "${BASH_VERSINFO[0]}" != "" && ${BASH_VERSINFO[0]} -ge 3 ]]; then
        if [[ "$1" =~ $2 ]]; then
            return 0
        else
            return 1
        fi
    else
        if (echo "$1" | grep -E "$2" >/dev/null 2>&1); then
            return 0
        else
            return 1
        fi
    fi
}

function like_glob() {
    case "$1" in
        $2) dbg "Glob match check:  $1 matches $2" ; return 0 ;;
        *)  dbg "Glob match check:  $1 does not match $2" ; return 1 ;;
    esac
}

function like() {
    local STRING="$1" MATCH="$2" MSG="$3"

    if [[ "${MATCH#/}" != "$MATCH" && "${MATCH%/}" != "$MATCH" ]]; then
        MATCH="${MATCH#/}"
        MATCH="${MATCH%/}"
        if like_regexp "$STRING" "$MATCH" ; then
            pass "$MSG"
            return 0
        else
            fail "$MSG:  $STRING =~ /$MATCH/ is false"
        fi
    else
        if like_glob "$STRING" "$MATCH" ; then
            pass "$MSG"
            return 0
        else
            fail "$MSG:  $STRING does not match $MATCH"
        fi
    fi
}

function unlike() {
    local STRING="$1" MATCH="$2" MSG="$3"

    if [[ "${MATCH#/}" != "$MATCH" && "${MATCH%/}" != "$MATCH" ]]; then
        MATCH="${MATCH#/}"
        MATCH="${MATCH%/}"
        if like_regexp "$STRING" "$MATCH" ; then
            fail "$MSG:  $STRING !~ /$MATCH/ is false"
        else
            pass "$MSG"
            return 0
        fi
    else
        if like_glob "$STRING" "$MATCH" ; then
            fail "$MSG:  $STRING matches $MATCH"
        else
            pass "$MSG"
            return 0
        fi
    fi
}

function finish() {
    if planned ; then unplan ; fi
    echo "All $SHUT_TESTS_DONE tests passed."
    return 0
}
