
function check_source {
    if [ -f ${1} ]; then
        source ${1}
        printf "source ${1}\n"
    else
        printf "no ${1}\n"
    fi
}

function prepend_path {
    if [ -d "$1" ] && [[ ":$PATH:" != *":$1:"* ]]; then
        # ${variable:+value} means check whether variable is defined
        # and has a non-empty value, and if it does gives the result
        # of evaluating value. Basically, if PATH is nonblank
        # to begin with it sets it to "$1:$PATH"; if it's blank it
        # sets it to just "$1" (note the lack of a colon).
        PATH="$1${PATH:+":$PATH"}"
    fi
}
