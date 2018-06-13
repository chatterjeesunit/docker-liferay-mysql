#!/bin/sh

echo "Starting Elastic Search Server"
cd $ELASTIC_HOME
./elasticsearch -d

echo "sleeping for 30 seconds"
sleep 30

echo "Startup complete"

