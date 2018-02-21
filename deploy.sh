#!/bin/bash

export PORT=5100
export MIX_ENV=prod
export GIT_PATH=/home/tasks1/src/tasks1

PWD=`pwd`
if [ $PWD != $GIT_PATH ]; then
	echo "Error: Must check out git repo to $GIT_PATH"
	echo "  Current directory is $PWD"
	exit 1
fi

if [ $USER != "tasks1" ]; then
	echo "Error: must run as user 'tasks1'"
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
if [ -d ~/www/tasks1 ]; then
	echo mv ~/www/tasks1 ~/old/$NOW
	mv ~/www/tasks1 ~/old/$NOW
fi

mkdir -p ~/www/tasks1
REL_TAR=~/src/tasks1/_build/prod/rel/tasks1/releases/0.0.1/tasks1.tar.gz
(cd ~/www/tasks1 && tar xzvf $REL_TAR)

crontab - <<CRONTAB
@reboot bash /home/tasks1/src/tasks1/start.sh
CRONTAB

#. start.sh
