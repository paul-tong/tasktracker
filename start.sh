#!/bin/bash

export PORT=5106

cd ~/www/tasktracker
./bin/tasktracker stop || true
./bin/tasktracker start
