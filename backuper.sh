#!/bin/bash
BPATH1='/home/backup/city/' #directories with backup
BPATH2='/home/backup/city.front/'
BPATH3='/home/backup/cms/'
WPATH1='/home/project/city/' #directories for backup
WPATH2='/home/project/city.front/'
WPATH3='/home/project/cms/'
EXCLUDE1='--exclude sessions/* --exclude php_log.log'
EXCLUDE2='--exclude sessions/* --exclude php_log.log'
EXCLUDE3='--exclude sessions/* --exclude php_log.log --exclude share/*'

for i in `seq 1 3`;
do
	t1=BPATH$i
	t2=WPATH$i
	t3=EXCLUDE$i
	BPATH=$(eval echo \$$t1)
	WPATH=$(eval echo \$$t2)
	EXCLUDE=$(eval echo \$$t3)
	
	cd $BPATH

	prevfile=$(ls -1t | head -1) #file for compare
	tar czf $(date +%Y%m%d-%H%M%S).tgz $WPATH $EXCLUDE

	if [ ${#prevfile} = 0 ]; then
		echo "created first backup"
	else
		curfile=$(ls -1t | head -1)
		diffexit=$(zdiff $prevfile $curfile)
		
		if [ ${#diffexit} = 0 ]; then
			echo "previous not changed"
			rm $curfile
		else
			echo "created new backup"
		fi
	fi
done

exit $?
