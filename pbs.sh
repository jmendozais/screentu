#!/bin/bash
/bin/bash config.sh
set -ex 
# TODO: move to config file
user_email="jmendozais@gmail.com"

function send_job {
# Send a task
# Input
# - remote address
# - task_name
# - task_type: cpu, gpu
# - command to execute

remote=$1
task_type=$2
task_name=$3
cmd=$4

tmp=/tmp/${RANDOM}.pbs
touch ${tmp}

echo "#PBS -N ${task_name}" >> ${tmp}
if [ ${task_type} = "cpu" ]; 
then 
    echo "#PBS -l nodes=1:ppn=14:gpus=0" >> ${tmp}
else 
    echo "#PBS -l nodes=1:ppn=14:gpus=1" >> ${tmp}
fi

# TODO: enable
#echo "#PBS -o ~/.pbs/${task_name}.o" >> ${tmp}
#echo "#PBS -e ~/.pbs/${task_name}.e" >> ${tmp}
echo "#PBS -m ae -M ${user_email}" >> ${tmp}

echo "${cmd}" >> ${tmp}

if ssh ${remote} '[ ! -d /.pbs ]';
then
    ssh ${remote} "mkdir -p ~/.pbs"
fi

scp ${tmp} "${remote}:~/.pbs/${task_name}.pbs"
ssh ${remote} "qsub ~/.pbs/${task_name}.pbs"

}

# test
#send_job manati gpu test1 "echo \'Test command\'"

send_job manati gpu segment "echo \'Test command\'"

