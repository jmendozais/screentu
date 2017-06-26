function start {
machine=$1
session=$2 
cmd=$3
ssh $machine "/usr/bin/screen -S ${session} -dm bash;"
ssh $machine "/usr/bin/screen -S ${session} -X stuff \"cd lung-nodule-detection;\"^M"
ssh $machine "/usr/bin/screen -S ${session} -X stuff \"${cmd}\"^M"
}

function close {
ssh $1 screen -X -S $2 quit
}

function stop-task {
close bezier $1
close babbage $1
close prim $1
close phong $1
close minsky $1
}

function qall {
ssh bezier "killall screen"
ssh babbage "killall screen"
ssh prim "killall screen"
ssh phong "killall screen"
ssh minsky "killall screen"
}
