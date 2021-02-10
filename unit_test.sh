#!/bin/bash

TEST_ARRAY=(
'##################		    BUILTINS			#################'
#### PWD ####
'pwd'
'pwd "useless argument"'
'unset PWD ; pwd'
#### ECHO ####
'echo | cat -e'
'echo hola buenos dias | cat -e'
'echo -n hola que tal bocadillo digital | cat -e'
#### ENV ####
'env | grep USER'
#### EXPORT ####
'export Z=z ; echo $Z'
'export A=a B=b C=c; echo $A$B$C'
'export zz zzz= zzzz=asd ; echo $zz$zzz$zzzz; export | grep zz'
'export =a ; echo $a'
'export /dont/export/this=hola ; export | grep /dont/export/this'
'export A=a=a=a=a=a; echo $A'
'export A B C; echo $A$B$C'
'export $'
'export ?=42'
#### UNSET ####
'unset'
'export A=a ; unset A ; echo $A'
'export A=a B=b C=c ; unset A asd B asd ; echo $A$B$C'
#### CD ####
'cd ; pwd'
'unset HOME ; cd ; pwd'
'cd .; pwd'
'cd ..; pwd'
'cd ..; echo $OLDPWD; pwd'
'unset OLDPWD; cd .. ; echo $OLDPWD; pwd'
"cd ' /'; pwd"
'cd ../../ ; pwd'
'cd ../../../../../../.. ; pwd'
'cd dirwithoutpermissions'
#### EXIT ####
'exit'
'exit 42'
'exit -42'
'exit 512'
'exit 1407'
'exit 21 42'
'exit notanumber'
'################	NO ENVIRONMENT (env -i ./minishell)	#################'
'cd'
'pwd'
'echo $PWD'
'cd .. ; echo $OLDPWD'
'./lscp'
'################		COMMAND EXECUTION	        #################'
'ls'
'/bin/ls'
'./lscp'
'cd dir ; ../lscp'
'cd dir/encoreuneautredir ; ../../lscp'
'df -h | head -2'
'/'
'../'
'/..'
'..'
'ls imnotaflag meneither'
'idontexist'
'./meneither'
'./dir'
'touch ucantexecme.e ; chmod 000 ucantexecme.e ; ./ucantexecme.e'
'################   		SYNTAX ERRORS			#################'
';'
'|'
'|b'
'a|||b'
'> > a'
'< < a'
'< >> a'
'>>> a'
'<<<< a'
'a<<<<'
'pwd >;'
';pwd'
'pwd ;;'
'################		    QUOTES			#################'
'echo "$HOME"'
"echo '\$HOME'"
"echo ' \"\$HOME\" '"
"echo \"'\$HOME'\""
"echo \" '\$PWD' \\\"\$PWD\\\" '\$PWD' \"" "echo \"\\\$HOME\""
"echo \"'\$'\""
"echo \\\\\n"
"echo \"< no pipe | or semicolon will ; stop me >\""
'bash -c "I am not a command" "Im the program name"'
'pwd" should not work"'
'echo\" should not work neiter\"'
'################		    PIPES			#################'
'echo 5 + 3 | bc'
'ls | wc | wc -l | bc'
'echo "cat traveler" | cat | cat | cat | cat | cat | cat'
'################	        RIGHT REDIRECTION		#################'
'> a ; ls'
'pwd > a ; cat a'
'ls > a -f ; cat a'
'echo entre el clavel y la rosa > a su majestad es coja; cat a'
'> a echo cucu cantaba la rana; cat a'
'echo "redirection party trick" > a > b > c > d ; ls ; cat d'
'notacommand > a'
'pwd > dir'
'ls > a imnotaflag meneither'
'################	        DOUBLE REDIRECTION		#################'
'>> a; ls'
'pwd >> a; cat a'
'echo double the redirection double the fun >> a ; cat a'
'pwd >> a ; echo apendicitis >> a ; cat a'
'pwd >> a ; ls >> a -f ; cat a'
'echo entre el clavel y la rosa >> a su majestad es coja ; cat a'
'>> a echo cucu cantaba la rana; cat a'
'echo "party trick x2" >> a >> b >> c >> d ; ls ; cat d'
'notacommand >> a'
'pwd >> dir'
'ls >> a imnotaflag meneither'
'################	    	LEFT REDIRECTION		#################'
'touch a ; < a'
'echo pim pam > pum ; cat < pum'
'echo ayayay > a; echo im a butterfly > b ; cat < a < b'
'touch a b c; echo sorry > d; cat < a < b < c < d'
'echo ayayay > a ; cat < doesnotexist < a'
'< doesnotexist'
'cat < doesnotexist'
'cat < dir'
)

usage() {
    printf "usage: ./unit_test.sh [--help | -h] [--no-error | -n] [--builtins | -b] [--no-environment | -e]\n"
    printf "                      [--cmd-execution | -c] [--syntax-error | -s] [--quotes | -q] [--pipes | -p]\n"
    printf "                      [--right-redirection | -r] [--left-redirection | -l] [--double-redirection | -d]\n"
    exit
}

GREEN=$(tput setaf 2)
RED=$(tput setaf 1)
YELLOW=$(tput setaf 3)
ROSITA=$(tput setaf 5)
BLUE=$(tput setaf 4)
MARRONMIERDA=$(tput setaf 8)
COLORBONITO=$(tput setaf 12)
NC=$(tput sgr0)

HELP=0
ERROR=1
DFL_TEST=1
TO_TEST=()
OTHER_ARGUMENTS=()
for arg in "$@"
do
    case $arg in
	-h|--help)
	HELP=1
	shift
	;;
        -n|--no-error)
	ERROR=0
        shift
        ;;
	-b|--builtins)
	DFL_TEST=0
	TO_TEST+=('BUILTINS')
	shift
	;;
	-e|--no-environment)
	DFL_TEST=0
	TO_TEST+=('ENVIRONMENT')
	shift
	;;
	-c|--cmd-execution)
	DFL_TEST=0
	TO_TEST+=('EXECUTION')
	shift
	;;
	-s|--syntax-error)
	DFL_TEST=0
	TO_TEST+=('SYNTAX')
	shift
	;;
	-q|--quotes)
	DFL_TEST=0
	TO_TEST+=('QUOTES')
	shift
	;;
	-p|--pipes)
	DFL_TEST=0
	TO_TEST+=('PIPES')
	shift
	;;
	-r|--right-redirection)
	DFL_TEST=0
	TO_TEST+=('RIGHT')
	shift
	;;
	-l|--left-redirection)
	DFL_TEST=0
	TO_TEST+=('LEFT')
	shift
	;;
	-d|--double-redirection)
	DFL_TEST=0
	TO_TEST+=('DOUBLE')
	shift
	;;
	*)
	OTHER_ARGUMENTS+=("$1")
        shift
        ;;
    esac
done

for args in ${OTHER_ARGUMENTS[@]}
do
    printf "${RED}Error:$NC $args: not a valid option\n\n"
    usage
done

if [[ $HELP -eq 1 ]]
then
    usage
fi

if [[ ! -f ../Makefile ]]; then printf "${RED}Error:$NC There is no Makefile to build your minishell in ../"
    printf "\nMake sure to clone this repo in the root of your project\n"
    printf "\n${RED}aborting test...\n\n$NC"
    exit 1
fi

make -C ..

if [[ ! -f ../minishell ]]; then
    printf "${RED}Error:$NC There is no executable called minishell in ../"
    printf "\n\n${RED}aborting test...\n\n$NC"
    exit 1 
fi

cp ../minishell .
printf "copying your minishell to the current directory...\n"

rm -rf diff.txt

if  [[ ! -d dir || ! -d dir/encoreuneautredir ]]; then
    mkdir dir dir/encoreuneautredir
    printf "creating directories ${ROSITA}dir$NC, ${ROSITA}dir/encoreuneautredir$NC...\n"
fi
if [[ ! -d dirwithoutpermissions ]]; then
    mkdir -m 0000 dirwithoutpermissions
    printf "creating directory ${ROSITA}dirwithoutpermissions$NC...\n"
fi
cp $(which ls) lscp
printf "%s\n" "copying ${ROSITA}$(which ls)$NC to ${ROSITA}lscp$NC..."

printf "\n\t\t\t    ${YELLOW}[ MINISHELL UNIT TEST ]$NC\n\n\n"

#KEYWORD=esternocleidomastoideo ###############
#echo "echo $KEYWORD" > testfile #############
#./minishell < testfile > hpc ###############
#sed "s/$KEYWORD//" hpc > hp #################

TOTAL=0
ENV=""
for val in "${TEST_ARRAY[@]}"
do
    if [[ "$val" = *ENVIRONMENT* ]]
    then
	ENV="env -i"
    elif [[ "$val" = *EXECUTION* ]]
    then
	ENV=""
    fi
    if [[ "$val" = *####* ]]
    then
	if [[ DFL_TEST -eq 1 ]]; then
	    printf "%s" "${NC}$val"
	else
	    TEST_SECTION=0
	    for section in ${TO_TEST[@]}
	    do
		if [[ "$val" = *$section* ]]; then
		    printf "%s" "${NC}$val"
		    TEST_SECTION=1
		    if [[ $ERROR == 1 ]]; then
			printf " ${COLORBONITO}STDERR$NC"
		    fi
		    continue;
		fi
	    done
	fi
	if [[ $ERROR == 1 && $DFL_TEST == 1 ]]; then
	    printf " ${COLORBONITO}STDERR$NC"
	fi
	if [[ $DFL_TEST == 1 || $TEST_SECTION == 1 ]]; then
	    printf "\n"
	fi
	continue 
    fi
    if [[ $DFL_TEST -eq 0 && $TEST_SECTION -eq 0 ]]
    then
	continue
    fi
#	echo "$val" > testfile ########
    TESTOK=0
    $ENV bash -c "$val" minishell > out1 2> err1
    RET1=$?
    rm -rf a b c d
    $ENV ./minishell -c "$val" > out2 2> err2 ######   #####
    RET2=$?
#	awk 'NR==FNR{a[$0]=1;next}!a[$0]' out2 hp > p #############3
#	printf "${YELLOW}p is$NC $(cat p)\n" ##################
#	awk 'NR==FNR{a[$0]=1;next}!a[$0]' hp out2 > pc ##############
#	printf "${YELLOW}pc is$NC $(cat pc)\n" ##################
#	printf "${YELLOW}out2 was$NC\n $(cat out2)\n" ##############
#	sed "s/$(cat p)//" pc > out2 ################### 
#	printf "${YELLOW}now out2 is$NC $(cat out2)\n" ####################
    rm -rf a b c d p pc ###############
    if [[ $(uname) == "Darwin" ]]; then
        sed -i "" 's/line 0: //' err1
	#	sed -i "" 's/.*minishell: -c: `.*//' err1
	#	sed -i "" 's/ -c://' err1
    else
        sed -i 's/line 0: //' err1
	#	sed -i 's/.*minishell: -c: `.*//' err1
	#	sed -i 's/ -c://' err1
    fi
    if [[ $(cat out2) == "exit" ]];then
	echo exit >> out1
    fi
    DIFF=$(diff out1 out2) 
    ERRDIFF=$(diff err1 err2)
    if [[ "$DIFF" == "" && $RET1 == $RET2 ]]; then
	TESTOK=1
    fi
    if [[ $TESTOK == 0 || ($ERROR == 1 && $ERRDIFF != "" ) ]]
    then
	if [[ $ENV == "" ]]; then
	    printf "%s\n" "${YELLOW}$val$NC" >> diff.txt
	else
	    printf "%s\n" "${YELLOW}$ENV ./minishell: $val$NC" >> diff.txt
	fi
	printf "${ROSITA}< bash       (exited with %d)$NC\n" "$RET1" >> diff.txt
	printf "${ROSITA}> minishell  (exited with %d)\n$NC" "$RET2" >> diff.txt
    fi

    if [[ $TESTOK == 1 ]]
    then
	PASSED=$((PASSED+1))
	printf "%-80s[PASS]$NC" "${GREEN}$val"
    else
	printf "%-80s[FAIL]$NC" "${RED}$val"
	if [[ "$DIFF" != "" ]]; then
		printf "%s\n" "${COLORBONITO}----- STDOUT -----$NC" >> diff.txt
		diff out1 out2 >> diff.txt
	fi
    fi

    if [[ $ERROR == 1 && "$ERRDIFF" == "" ]]
    then
	if [[ $TESTOK == 1 ]]; then
	    printf "${GREEN} [    ]$NC\n"
	else printf "${RED} [    ]$NC\n"
	fi
    elif [[ $ERROR == 1 && "$ERRDIFF" != "" ]]
    then
	if [[ $TESTOK == 1 ]]; then
	    printf "${GREEN} [${MARRONMIERDA}FAIL${GREEN}]$NC\n"
	else
	    printf "${RED} [${MARRONMIERDA}FAIL${RED}]$NC\n"
	fi
	printf "%s\n" "$COLORBONITO----- STDERR -----$NC" >> diff.txt
	diff err1 err2 >> diff.txt
    else
	printf "\n"
    fi

    if [[ "$DIFF" != "" || $RET1 != $RET2 || ($ERROR == 1 && $ERRDIFF != "") ]]
    then
	printf "\n\n" >> diff.txt
    fi

    TOTAL=$((TOTAL+1))
done

printf "\n\n\t${GREEN}$PASSED$NC tests ${GREEN}passed$NC from a total of $TOTAL tests"
printf "  ||  ${GREEN}$PASSED passed$NC - "
if [[ $((TOTAL - PASSED)) == 0 ]]; then
	printf "${GREEN}$((TOTAL - PASSED)) failed$NC"
else
	printf "${RED}$((TOTAL - PASSED)) failed$NC"
fi

printf "\n\n\t\t\'cat diff.txt | less\'  for detailed information\n\n"

rm -rf minishell out1 out2 err1 err2 a b c d pum lscp hpc hp testfile
chmod +r dirwithoutpermissions
rm -rf ucantexecme.e dir dir/encoreuneautredir dirwithoutpermissions
