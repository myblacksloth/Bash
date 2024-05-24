#!/bin/bash
# abilito gli alias nello script
shopt -s expand_aliases

# 
# 
#
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
pushd "${SCRIPT_DIR}"
# 
# 
#  

exesys=$(uname -s)
if [[ ${exesys} == "Darwin" ]]; then
	echo "Rilevato MacOS"
	which gsed > /dev/null
	exitcode=$?
	if [ ${exitcode} != 0 ]; then
		echo "Error: gnu-sed non installato"
		exit 1
	fi
	alias sed='gsed'
fi

# 
# 
# 

inputFileName=""
pdfFileTitle=""

while getopts "f:t:" opt; do
        case ${opt} in
    	f)
			inputFileName=${OPTARG}
			;;
		t)
			pdfFileTitle=${OPTARG}
			;;
        ?)
            echo "Invalid option: -${OPTARG}."
            exit 1
            ;;
    	esac
done

if [[ ${inputFileName} == "" ]]; then
	echo "Errore: Nessun file indicato"
	exit 2
fi

# 
# 
# 

profilesDir=""

# copio il profilo per i PDFA
if [[ ${exesys} == "Darwin" ]]; then
	profilesDir="/usr/local/Cellar/ghostscript/10.01.1/share/ghostscript/10.01.1/lib"
elif [[ ${exesys} == "Linux" ]]; then
	# todo
	profilesDir=""
fi
pdfa_profile="PDFA_def.ps"
profile_file="${profilesDir}/${pdfa_profile}"
customProfile="./profile.ps"
cp ${profile_file} ${customProfile}

# imposto il nome del file di output
outputFileName="${inputFileName}.PDFA.pdf"

# imposto la sostituzione del titolo del file
titleSubstitution="s/(Title)/(${pdftitle})/g"

# effettuo le sostituzioni
sed -i "${titleSubstitution}" ${customProfile}
sed -i 's/(srgb.icc)/(.\/colors\/sRGB2014_v2.icc)/g' ${customProfile}

gs -q -dNOPAUSE -dBATCH -dNOSAFER -sDEVICE=pdfwrite -sOutputFile=${outputFileName} -dPDFA=2 -dPDFACompatibilityPolicy=1 -sColorConversionStrategy=RGB -sProcessColorModel=DeviceRGB ${customProfile} ${inputFileName}

exitvalue=$?
if [ ${exitvalue} != 0 ]; then
	echo "===== ERRORE ====="
else
	echo "===== OK ====="
fi


rm -f ${customProfile}

#
#
#
popd
#
#
#

