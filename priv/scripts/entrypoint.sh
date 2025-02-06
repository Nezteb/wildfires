#!/bin/sh

printf "Hostname: %s\n" "$(hostname -f)"
printf "env:\n%s\n" "$(env | sort)"

/app/bin/wildfires eval Wildfires.Release.migrate
/app/bin/wildfires start
