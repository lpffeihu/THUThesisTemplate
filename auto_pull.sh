#!/bin/sh

NAME=main.tex

while [ 1 ]; do
	git remote update
	LOCAL=$(git rev-parse @)
	REMOTE=$(git rev-parse @{u})
	BASE=$(git merge-base @ @{u})
	if [ $LOCAL = $REMOTE ]; then
		echo "Up-to-date"
	elif [ $LOCAL = $BASE ]; then
		echo "Need to pull"
		git pull
		texify.exe --pdf --tex-option=--interaction=errorstopmode --tex-option=--synctex=1 "$NAME"
	elif [ $REMOTE = $BASE ]; then
		echo "Need to push"
	else
		echo "Diverged"
	fi
	sleep 10;
done;
