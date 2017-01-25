#! /bin/bash

for video in `find /groups/gray/sam/Big_experiment_video -type f -name "*.avi"`
do
    logName=$(basename $video .avi)
    bsub -q short -R "rusage[mem=8000]" -W 8:00 -e ~/jobLogs/$logName.err -o ~/jobLogs/$logName.log matlab -nosplash -nojvm -nodesktop -r "quantifyMovement_video('$video')"
done
