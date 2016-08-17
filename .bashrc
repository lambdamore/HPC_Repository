### Default .bashrc Setup
### By Baoxiang Pan

# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

. /data/shell-syswide-setup/system-wide-bashrc

### Software modules to automatically load.  Cluster_Defaults provides a
### basic set of software.  Comment it out if you don't want any and wish to
### load your own.  Add more below to select your own specific software to
### load each time you login.   Type 'module available' to see entire list.

module load Cluster_Defaults
alias math="module load Mathematica && math"
alias matlab="module load MATLAB && matlab"
alias julia="module load julia && julia"
alias sw="cd /data/apps/user_contributed_software/baoxianp ; ls"
alias back="cd /data/users/baoxianp ; ls"
alias wrf="cd /pub/baoxianp/Build_WRF"
alias send='function __myscp() { scp $* penn@169.234.4.155:/Users/penn/Documents;}; __myscp'
alias job='function __qsub() { printf "#!/bin/bash\n#$ -N $*\n#$ -q chrs\n#$ -m beas\n" > $*;}; __qsub'
alias pub="cd /pub/baoxianp"
alias ..="cd .."
alias d='function __wd() { DATE=`date +%Y-%m-%d`; name=${*}_${DATE}; vim $name;}; __wd'
