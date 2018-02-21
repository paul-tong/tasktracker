#!/bin/bash

export PORT=5105

cd ~/www/tasktracker
./bin/tasktracker stop || true
./bin/tasktracker start

