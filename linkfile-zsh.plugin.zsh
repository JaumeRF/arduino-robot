###########################################################
#							  #
#                   LINKFILE PLUGIN   			  #
#							  #
#	      CREATED BY: Jaume Ros Fuster		  #
#                      15/06/2020			  #
#							  #
#             https://github.com/JaumeRF		  #
#							  #
###########################################################

##########################
#       Settings         #
##########################

default var_prefix "ƒ"
default home_path= "${HOME}"

if [ -f "${HOME}/.linkfile/.indexfile" ]
then
    default index_file "${HOME}/.linkfile/.indexfile";

else

    mkdir ${HOME}/.linkfile;
    touch ${HOME}/.linkfile/.indexfile;
    default index_file "${HOME}/.linkfile/.indexfile";

fi

BLUE='\033[0;34m'
RED='\033[0;31m'
PURPLE='\033[1;35m'
NC='\033[0;0m'


##########################
#       Link a path      #
##########################

function linkfile () {


    test "$2" || 2="."
    file=$2:A

    test "$1" || 1="$(basename "$file")"
    name=$(echo "$1" | tr " " "_")

    if test -e "$file"  
    then 
        if [ ! -z "$3" ]
        then
            echo "${PURPLE}------------------------------------"
            echo ""
            echo -e "${RED}Action requires: ${BLUE}linkfile${NC} (or the alias: lf) ${BLUE}[name]${NC} (if none then the name will be the same as the directory) ${BLUE}[path]${NC} (if none then the path will be the actual directory path)"
            echo ""
            echo "${PURPLE}------------------------------------"
        else
            if [ -f "$file" ]
            then
	            file_path=$(echo "$file" | sed  's/[^/]*$//')
        
            else
                file_path=$(echo "$file")
            fi

            if  grep -q "\[0\;0m "$name" " "${index_file}" 
            then
                echo ""
                echo "The name is already in use or the name is in conflict with a directory";
                echo ""

            elif grep -q "$file_path" "${index_file}"
            then
                echo "${PURPLE}------------------------------------"
                echo ""
                echo "This file or directory has another shortcut. Do you wish to continue?";
                select yn in "Yes" "No"; do
                    case $yn in
                    Yes ) echo "${PURPLE}<·>${NC} "$name" ${PURPLE}->${NC} "$(echo "$file_path")"" >> "${index_file}"; echo -e "\n"$name" added successfully\n"; break;;
                    No ) break;;
                    esac
                done 

            else
                echo "${PURPLE}<·>${NC} "$name" ${PURPLE}->${NC} "$(echo "$file_path")"" >> "${index_file}";
                echo "${PURPLE}------------------------------------"
                echo ""
                echo " "$name" added successfully"
                echo ""
                echo "${PURPLE}------------------------------------"
            fi
        fi
    else
            echo "${PURPLE}------------------------------------"
            echo ""
            echo "${RED}This path doesn't exist:${NC} "$file""
            echo ""
            echo "${PURPLE}------------------------------------"
    fi

}

##############################
#       Go to a path         #
##############################

function "${var_prefix}" () {
 
    if  grep -q "\[0\;0m "$1" " "${index_file}" 
    then
        linkpath=$(grep -w "\[0\;0m "$1" " "${index_file}")
        cleanpath=$(echo "$linkpath" | sed 's/[^ ]*[ ][^ ]*[ ][^ ]*[ ]//')
        cd "$cleanpath" 
    else
        echo ""
        echo "${RED}This link doesn't exist: "$1""
        echo ""
    fi

}


##############################
#      List the links        #
##############################

function linkfile_list () {

    echo "${PURPLE}--------------------------------------${NC}"
    echo ""
    cat "${index_file}"
    echo ""
    echo "${PURPLE}--------------------------------------${NC}"
}


##############################
#       Rename a link        #
##############################

function linkfile_rename () {

    if [ -z "$1" ] || [ -z "$2" ]
    then
        echo "${PURPLE}------------------------------------${NC}"
        echo ""
        echo "${RED}Action requires:${NC} ${BLUE}linkfile_rename${NC} (or the alias: lfrnm) ${BLUE}[old-name]${NC} ${BLUE}[new-name]${NC}"
        echo ""
        echo "${PURPLE}------------------------------------${NC}"
    else
        if  grep -q "\[0\;0m "$1" " "${index_file}" 
        then
            linkpath=$(grep -w "\[0\;0m "$1" " "${index_file}")
            cleanpath=$(echo "$linkpath" | sed 's/[^ ]*[ ][^ ]*[ ][^ ]*[ ]//')

            mv "${HOME}/.linkfile/.indexfile" "${HOME}/.linkfile/.indexfile-old";
            grep -vwE "$1" "${HOME}/.linkfile/.indexfile-old" > "${HOME}/.linkfile/.indexfile";
            rm "${HOME}/.linkfile/.indexfile-old";

            echo "${PURPLE}<·>${NC} "$2" ${PURPLE}->${NC} "$(echo "$cleanpath")"" >> "${index_file}";
            echo "${PURPLE}------------------------------------${NC}"
            echo ""
            echo " "$1" -> "$2" "
            echo ""
            echo "${PURPLE}------------------------------------${NC}"
        else
            echo "${PURPLE}------------------------------------${NC}"
            echo ""
            echo "${RED}Th %B(is link doesn't)%b exist:${NC} "$1""
            echo ""
            echo "${PURPLE}------------------------------------${NC}"
        fi
    fi

}


##############################
#      Remove one link       #
##############################

function linkfile_remove () {

    if [ "$1" ] && [ -z "$2" ]
    then 
        echo "${PURPLE}------------------------------------${NC}"
        echo ""
        echo "${RED}Do you wish to delete the link:${NC} "$1" ?"
        select yn in "Yes" "No"; do
            case $yn in
                Yes )  mv "${HOME}/.linkfile/.indexfile" "${HOME}/.linkfile/.indexfile-old";
                    grep -vwE "$1" "${HOME}/.linkfile/.indexfile-old" > "${HOME}/.linkfile/.indexfile";
                    rm "${HOME}/.linkfile/.indexfile-old"; break;;
                No ) break;;
            esac
        done
    else
        echo "${PURPLE}------------------------------------${NC}"
        echo ""
        echo "${RED}Action requires:${NC} ${BLUE}linkfile_remove${NC} (or the alias: lfrm) ${BLUE}[name]${NC}"
        echo ""
        echo "${PURPLE}------------------------------------${NC}"
    fi

}


##############################
#      Delete all links      #
##############################

function linkfile_delete () {

    echo "${PURPLE}------------------------------------${NC}"
    echo ""
    echo "${RED}Do you wish to delete all your links?${NC}"
    select yn in "Yes" "No"; do
        case $yn in
            Yes ) rm "${index_file}";touch ${HOME}/.linkfile/.indexfile;    
		default index_file "${HOME}/.linkfile/.indexfile"; break;;
            No ) break;;
        esac
    done
}


##############################
#         Shortcuts          #
##############################

alias lf=linkfile
alias lfls=linkfile_list
alias lfrm=linkfile_remove
alias lfdlt=linkfile_delete
alias lfrnm=linkfile_rename

# to go to a file or directory
# write '§' (you can change this key in default var_prefix in the Settings section) and the name of your link

##############################
#         Development        #
##############################


SOURCE=${(%):-%N}
prueba (){

#    echo "$( dirname ${SOURCE})"
#    echo "${(%):-%N}"
#    echo "${(%):-%x}"
    echo "${nose}"
#    echo "${(%):-%d}" #<--- este no me vale
}

