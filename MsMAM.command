#!/bin/bash
# Program:
# This porgram will try to package ipa file with Microst MAM func

# History:
# 2017/01/24 Alex Hsu First Release
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH

#def function
function setCustomedVar() {
	declare -x $1=$2
}

#define var
MAMCmd=/Users/prode/Desktop/MDM/Contents/MacOS/IntuneMAMPackager
SHAHashCode=0CFDA9E07D328E164A037E0DBC538DEBE92ADD00
outputPostfix=$(date +%Y%m%d_%H%M%S)

#Verify workdir
#workdir=D:/temp/mam
workdir=/Users/prode/Desktop/MDM
read -p "Input working Directory Default=> ${workdir} " NewWorkDir
test ! -z ${NewWorkDir} && workdir=${NewWorkDir}
echo  "Your working ${workdir}"
echo -e "\n"
test !  -d ${workdir} && echo "Your workdir is neither a directory nor existing" && exit 0

#Verify source ipa
inputIpaCount=$(find ${workdir}/input -name "*.ipa" | wc -l)
#echo inputIpaCount:  ${inputIpaCount}

if [ ${inputIpaCount} -eq 1 ]; then
	existIPA=$(find ${workdir}/input -name "*.ipa" | while read ipacon ; do echo "$ipacon"  ; done)	
fi
#echo existIPA :  $existIPA
test  -f ${existIPA} && test ! -z ${existIPA}  && read -p "Verify your ipa location or change it : ${existIPA} " inputsourceName || read -p "type your sourceName name : " inputsourceName
test ! -z ${inputsourceName} && sourceName=${workdir}/input/${inputsourceName} || sourceName=${existIPA}

#read -p "type your source Ipa Name :  " sourceName
test ! -f ${sourceName} || test -z ${sourceName} && echo "Your source Ipa Doesn't exist => ${workdir}/input/${sourceName}" && exit 0

#Verify profile
read -p "type your profile name* : " profilename
test ! -f ${workdir}/profile/${profilename} && echo "Your profile Doesn't exist =>  ${workdir}/profile/${profilename}"  && exit 0 


#Execute MAM command
${MAMCmd} -i ${sourceName} -o ${workdir}/output/$(echo ${sourceName} | sed 's/.*\///g')_${outputPostfix}.ipa  -p ${workdir}/profile/${profilename} -c ${SHAHashCode}  -v true

#move source ipa to backup dir
mv -f ${sourceName}   ${workdir}/backup/Backup_${outputPostfix}_$(echo ${sourceName} | sed 's/.*\///g')

echo exitcode $$
exit 1



