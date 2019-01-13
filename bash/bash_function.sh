
function check_source {
    if [ -f ${1} ]; then
        source ${1} 
        printf "source ${1}\n"
    else 
        printf "no ${1}\n"
    fi 
}

