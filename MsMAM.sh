#!/bin/bash
# Program:
# This porgram will try to package ipa file with Microst MAM func

# History:
# 2017/01/24 Alex Hsu First Release
# 2017/01/25 Alex Hsu modidfy choice way of ipa&profile 
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH

#def function
function setCustomedVar() {
	declare -x $1=$2
}

function pressEnterAndExit() {
	echo -e "\n"
	read -p  "Press enter to exit!!"
	exit $1
}

#define var
MAMCmd=/Users/prode/Desktop/MDM/Contents/MacOS/IntuneMAMPackager
SHAHashCode=0CFDA9E07D328E164A037E0DBC538DEBE92ADD00
outputPostfix=$(date +%Y%m%d_%H%M%S)

#Verify workdir
#workdir=D:/temp/mam
workdir=/Users/prode/Desktop/MDM
read -p "Verify or change working Directory, Default=> ${workdir} " NewWorkDir
test ! -z ${NewWorkDir} && workdir=${NewWorkDir}
echo  "Your working ${workdir}"
echo -e "\n"
test !  -d ${workdir} && echo "Your workdir is neither a directory nor existing!" && pressEnterAndExit 0


#---- Verify source ipa ----
#inputIpaCount=$(find ${workdir}/input -name "*.ipa" | wc -l)
#if [ ${inputIpaCount} -eq 1 ]; then
#	existIPA=$(find ${workdir}/input -name "*.ipa" | while read ipacon ; do echo "$ipacon"  ; done)	
#fi
#test  -f ${existIPA} && test ! -z ${existIPA}  && read -p "Verify your ipa location or change it : ${existIPA} " inputsourceName || read -p "type your sourceName name : " inputsourceName
#test ! -z ${inputsourceName} && sourceName=${workdir}/input/${inputsourceName} || sourceName=${existIPA}
#test ! -f ${sourceName} || test -z ${sourceName} && echo "Your source Ipa Doesn't exist => ${workdir}/input/${sourceName}" && pressEnterAndExit 0

test $(find ${workdir}/input -type f -name "*.ipa" | wc -l) -eq 0 && echo "your IPA direction has no file => ${workdir}/input" && pressEnterAndExit 0
PS3='
please choice your IPA (number) :'
select choiceIPA in $(find ${workdir}/input -type f -name "*.ipa") ;
do 
# echo your choice is $choice
break
done

test ! -f ${choiceIPA} || test -z ${choiceIPA} && echo "Your source Ipa Doesn't exist => ${choiceIPA}" && pressEnterAndExit 0

#---- Verify profile ----
#read -p "type your profile name* : " profilename
#test ! -f ${workdir}/profile/${profilename} && echo "Your profile Doesn't exist =>  ${workdir}/profile/${profilename}"  && pressEnterAndExit 0 

test $(find ${workdir}/profile -type f | wc -l) -eq 0 && echo "your porfile direction has no file => ${workdir}/profile" && pressEnterAndExit 0
PS3='
please choice your profile (number) :'
select choiceProfile in $(find ${workdir}/profile -type f) ;
do 
# echo your choice is $choice
break
done

test ! -f ${choiceProfile} || test -z ${choiceProfile} && echo "Your source Ipa Doesn't exist => ${choiceProfile}" && pressEnterAndExit 0

#show chosed mam properties
echo -e "\n↓↓↓↓↓↓↓↓↓↓↓↓ Porperties List ↓↓↓↓↓↓↓↓↓↓↓↓"
(
printf '%s\t%s\t%s\n' "workdir" "=>" "${workdir}"
printf '%s\t%s\t%s\n' "choiced IPA" "=>" "${choiceIPA}"
printf '%s\t%s\t%s\n' "choiced profile" "=>" "${choiceProfile}"
printf '%s\t%s\t%s\n' "SHAHashCode" "=>" "${SHAHashCode}"
) | column -t -s $'\t'
echo -e  "↑↑↑↑↑↑↑↑↑↑↑↑ Porperties List ↑↑↑↑↑↑↑↑↑↑↑↑\n"

#Execute MAM command
#${MAMCmd} -i ${choiceProfile} -o ${workdir}/output/$(echo ${choiceProfile} | sed 's/.*\///g')_${outputPostfix}.ipa  -p ${workdir}/profile/${profilename} -c ${SHAHashCode}  -v true
${MAMCmd} -i ${choiceIPA} -o ${workdir}/output/$(basename -s .ipa ${choiceIPA})_${outputPostfix}.ipa  -p ${choiceProfile} -c ${SHAHashCode}  -v true

#move source ipa to backup dir
mv -f ${choiceIPA}   ${workdir}/backup/Backup_${outputPostfix}_$(echo ${choiceIPA} | sed 's/.*\///g')


pressEnterAndExit 0
