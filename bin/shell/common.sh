#!/bin/bash

VERSION="3.4.9"
VERSION_RELEASE="9"
VERSION_ONLY="3.4"
VERSION_STATE=""
VERSION_PREVIOUS="3.4.8"
VERSION_BRANCH="$VERSION_ONLY"
VERSION_NICK="$VERSION"
VERSION_STABLE="3.4.8"
DEVELOPMENT="false"

# Figure out if this is the final release
VERSION_FINAL="false"
if [ "$VERSION_RELEASE" == "0" -a "$DEVELOPMENT" == "false" ]; then
    VERSION_FINAL="true"
fi

# URLs for the various repositories
REPOSITORY_BASE_URL="http://svn.ez.no/svn/ezpublish"
TR_REPOSITORY_BASE_URL="http://svn.ez.no/svn/translations"
# This needs to be set correctly when a new branch is created
# e.g. stable/3.4 stable/3.5
REPOSITORY_BRANCH_PATH="stable/3.4"
REPOSITORY_STABLE_BRANCH_PATH="stable"

CURRENT_URL="$REPOSITORY_BASE_URL/$REPOSITORY_BRANCH_PATH"
TRANSLATION_URL="$TR_REPOSITORY_BASE_URL/$REPOSITORY_BRANCH_PATH/translations"
LOCALE_URL="$TR_REPOSITORY_BASE_URL/$REPOSITORY_BRANCH_PATH/locale"


VERSIONS="2.9 3.0 3.1 3.2 3.3 3.4"
STABLE_VERSIONS="3.0 3.1 3.2 3.3 3.4"
ALL_VERSIONS="$VERSIONS $VERSION_ONLY"
ALL_STABLE_VERSIONS="$STABLE_VERSIONS $VERSION_ONLY"


RES_COL=60
# terminal sequence to move to that column. You could change this
# to something like "tput hpa ${RES_COL}" if your terminal supports it
MOVE_TO_COL="echo -en \\033[${RES_COL}G"
# terminal sequence to set color to a 'success' color (currently: green)
SETCOLOR_SUCCESS="echo -en \\033[1;32m"
# terminal sequence to set color to a 'failure' color (currently: red)
SETCOLOR_FAILURE="echo -en \\033[1;31m"
# terminal sequence to set color to a 'warning' color (currently: magenta)
SETCOLOR_WARNING="echo -en \\033[1;35m"

# terminal sequence to set color to a 'file' color (currently: default)
SETCOLOR_FILE="echo -en \\033[1;30m"
# terminal sequence to set color to a 'directory' color (currently: blue)
SETCOLOR_DIR="echo -en \\033[1;34m"
# terminal sequence to set color to a 'executable' color (currently: green)
SETCOLOR_EXE="echo -en \\033[1;32m"

# terminal sequence to set color to a 'comment' color (currently: gray)
SETCOLOR_COMMENT="echo -en \\033[1;30m"
# terminal sequence to set color to a 'emphasize' color (currently: bold black)
SETCOLOR_EMPHASIZE="echo -en \\033[1;38m"
# terminal sequence to set color to a 'new' color (currently: bold black)
SETCOLOR_NEW="echo -en \\033[1;38m"


# terminal sequence to reset to the default color.
SETCOLOR_NORMAL="echo -en \\033[0;39m"

# Position handling
POSITION_STORE="echo -en \\033[s"
POSITION_RESTORE="echo -en \\033[u"

# Checks if ezlupdate is compiled
# Parameters: CHECK_ONLY
# CHECK_ONLY: If this is set to 1 it will not ask the interact with the user
function ezdist_check_ezlupdate
{
    local check
    check="$1"

    if [ ! -f bin/linux/ezlupdate ]; then
	[ "x$check" == "x1" ] && return 1
	echo "You do not have the ezlupdate program compiled"
	echo "this is required to create a distribution"
	echo
	echo "(cd support/lupdate-ezpublish3; qmake; make)"
	echo
	echo "NOTE: qmake may in some cases not be in PATH, provide the full path in those cases"
	echo

	while [ 1 ]; do
	    echo -n "Do you wish updatetranslation.sh to compile ezlupdate for you? [Yes|no] "
	    read make_it
	    make_it=`echo $make_it | tr A-Z a-z`
	    [ -z "$make_it" ] && make_it="y"
	    case "$make_it" in
		y|yes)
		    make_it="1"
		    ;;
		n|no|q|quit)
		    exit 1
		    ;;
		*)
		    echo "Invalid answer $make_it, use y|yes|n|no"
		    make_it=""
		    ;;
	    esac
	    if [ -n "$make_it" ]; then
		echo
		echo "Building ezlupdate"
		echo
		(cd support/lupdate-ezpublish3 &&
		    qmake &&
		    make)
		if [ $? -ne 0 ]; then
		    echo "Failed to build ezlupdate automatically"
		    exit 1
		fi
		break
	    fi
	done
	if [ ! -f bin/linux/ezlupdate ]; then
	    echo
	    echo "The compilation process for ezlupdate was successful but the executable"
	    echo "bin/linux/ezlupdate could not be found"
	    echo
	    echo "Try building the executable yourself"
	    exit 1
	fi
    fi
    return 0
}

# Makes sure ezlupdate is up to date by running qmake + make
# Returns 0 if everything was built successfully
function ezdist_update_ezlupdate
{
    echo "Building ezlupdate executable"
    echo
    (cd support/lupdate-ezpublish3 &&
	qmake &&
	make)
    if [ $? -ne 0 ]; then
	echo "Failed to build ezlupdate automatically"
	return 1
    fi
    if [ ! -f bin/linux/ezlupdate ]; then
	echo
	echo "The compilation process for ezlupdate was successful but the executable"
	echo "bin/linux/ezlupdate could not be found"
	echo
	echo "Try building the executable yourself"
	return 1
    fi
    return 0
}

# Returns 0 if the variable is considered undefined
# Currently this means if it contains the text 'undef'
function ezdist_is_undef
{
    if [ "$1" == "undef" ]; then
	return 0
    fi
    return 1
}

# Returns 0 if the variable is considered defined
# Currently this means if it does not contain the text 'undef'
function ezdist_is_def
{
    if [ "$1" == "undef" ]; then
	return 1
    fi
    return 0
}

# Returns 0 if the variable is considered empty
# Currently this means if it contains the text 'none' or is undefined
function ezdist_is_empty
{
    ezdist_is_undef "$1" && return 0
    if [ "$1" == "none" -o "$1" == "undef" ]; then
	return 0
    fi
    return 1
}

# Returns 0 if the variable is considered not empty
# Currently this means if it does not contain the text 'none' or is undefined
function ezdist_is_nonempty
{
    ezdist_is_undef "$1" && return 1
    if [ "$1" == "none" -o "$1" == "undef" ]; then
	return 1
    fi
    return 0
}
