#! /bin/bash

for video in `find /groups/gray/sam/Big_experiment_video -type f -name "*.mp4"`
do
    logName=$(basename $video .mp4)
    bsub -q short -R "rusage[mem=32000]" -W 3:00 -e ~/jobLogs/$logName.err -o ~/jobLogs/$logName.log matlab -nosplash -nojvm -nodesktop -r "quantifyMovement_video('$video')"
done
