#!/bin/bash

function debug {
  echo "creating debugging directory"
mkdir .debug
for word in ${rmthis}
  do
    if [[ "${word}" == *.sh ]] || [[ "${word}" == lib ]]
      then
        mv "${word}" .debug;
      fi
  done
}

rmthis=`ls`
echo ${rmthis}

ARGSU="${columns}"
INPUTSU="${tab_file}"
echo "arguments are "${ARGSU}
echo "inputs are "${INPUTSU}

COLU=\$"${columns}"
COLU=`echo ${COLU} | sed -e 's/,/,\\$/g'`
CMDLINEARG="awk '{ print "$COLU" }' IFS='\\t' OFS='\\t' "${INPUTSU}" >> filtered_"${INPUTSU}" "

echo ${CMDLINEARG};
chmod +x launch.sh

echo  universe                = docker >> lib/condorSubmitEdit.htc
echo docker_image            =  ubuntu:16.04 >> lib/condorSubmitEdit.htc ######
echo executable               =  ./launch.sh >> lib/condorSubmitEdit.htc #####
echo arguments                          = ${CMDLINEARG} >> lib/condorSubmitEdit.htc
echo transfer_input_files = ${INPUTSU}, launch.sh >> lib/condorSubmitEdit.htc
#echo transfer_output_files = output >> lib/condorSubmitEdit.htc
cat /mnt/data/apps/cut_columns/lib/condorSubmit.htc >> lib/condorSubmitEdit.htc

less lib/condorSubmitEdit.htc

jobid=`condor_submit -batch-name ${PWD##*/} lib/condorSubmitEdit.htc`
jobid=`echo $jobid | sed -e 's/Sub.*uster //'`
jobid=`echo $jobid | sed -e 's/\.//'`

#echo $jobid

#echo going to monitor job $jobid
condor_tail -f $jobid

debug

exit 0
