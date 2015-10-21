#! /bin/bash
START_TIME=$SECONDS
rm -r .vagrant
for i in `seq 1 10`;
do
	echo "Run ${i} started"
	vagrant destroy --force
	vagrant up
	echo "Run ${i} done"
done

ELAPSED_TIME=$(($SECONDS - $START_TIME))

echo "$(($ELAPSED_TIME/60)) min $(($ELAPSED_TIME%60)) sec"