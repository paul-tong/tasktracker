#!/bin/bash

export PORT=5105
export MIX_ENV=prod
export GIT_PATH=/home/tasktracker/src/tasktracker

PWD=`pwd`
if [ $PWD != $GIT_PATH ]; then
	echo "Error: Must check out git repo to $GIT_PATH"
	echo "  Current directory is $PWD"
	exit 1
fi

if [ $USER != "tasktracker" ]; then
	echo "Error: must run as user 'tasktracker'"
	echo "  Current user is $USER"
	exit 2
fi

mix deps.get
(cd assets && npm install)
(cd assets && ./node_modules/brunch/bin/brunch b -p)
mix phx.digest
mix release --env=prod

mkdir -p ~/www
mkdir -p ~/old

NOW=`date +%s`
if [ -d ~/www/tasktracker ]; then
	echo mv ~/www/tasktracker ~/old/$NOW
	mv ~/www/tasktracker ~/old/$NOW
fi

mkdir -p ~/www/tasktracker
REL_TAR=~/src/tasktracker/_build/prod/rel/tasktracker/releases/0.0.1/tasktracker.tar.gz
(cd ~/www/tasktracker && tar xzvf $REL_TAR)

crontab - <<CRONTAB
@reboot bash /home/tasktracker/src/tasktracker/start.sh
CRONTAB

#. start.sh
