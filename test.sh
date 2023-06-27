#!/bin/sh

aurora_bin=/opt/aurora/aurora
pre_cmd=''
post_cmd=''


runAurora(){
    $pre_cmd $aurora_bin $post_cmd
}


if [ $# -ne 0 ];  then

   if [[ "$@" == *"--log"* ]]; then
    post_cmd='--log'
   fi

   if [[ "$@" == *"--with-root"* ]]; then
    pre_cmd="pkexec env DISPLAY=$DISPLAY XAUTHORITY=$XAUTHORITY"
   fi

   if [[ "$@" == *"--help"* ]]; then
echo "usage: --log          -       enables logging
       --with-root    -       runs with eleavated privilages
       --help         -       helps!"
   else
    runAurora
   fi
else
    runAurora
fi
