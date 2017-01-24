#!/bin/bash
# Program:
# This porgram will try to package ipa file with Microst MAM func

# History:
# 2017/01/24 Alex Hsu First Release
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH

#define var
MAMCmd=/Users/prode/Desktop/MDM/Contents/MacOS/IntuneMAMPackager
SHAHashCode=0CFDA9E07D328E164A037E0DBC538DEBE92ADD00
outputPostfix=$(date +%Y%m%d_%H%M%S)

#Verify workdir
workdir=/Users/prode/Desktop/MDM
read -p "Input working Directory Default=> ${workdir} " NewWorkDir
test ! -z ${NewWorkDir} && workdir=${NewWorkDir}
echo  "Your working ${workdir}"
echo -e "\n" 
test !  -d ${workdir} && echo "Your workdir is neither a directory nor existing" && exit 0

#Verify source ipa
read -p "type your source Ipa Name :  " sourceName
test ! -f ${workdir}/input/${sourceName} && echo "Your source Ipa Doesn't exist => ${workdir}/input/${sourceName}" && exit 0

#Verify profile
read -p "type your profile name : " profilename
test ! -f ${workdir}/profile/${profilename} && echo "Your profile Doesn't exist =>  ${workdir}/profile/${profilename}"  && exit 0 


#Execute MAM command
${MAMCmd} -i ${workdir}/input/${sourceName} -o ${workdir}/output/${sourceName}_${outputPostfix}.ipa  -p ${workdir}/profile/${profilename} -c ${SHAHashCode}  -v true



