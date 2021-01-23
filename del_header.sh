#!/bin/bash

KEYWORD=esternocleidomastoideo

echo "echo $KEYWORD" > testfile
./minishell < testfile > a
sed "s/$KEYWORD//" a > hp

for arg in "$@"
do
	echo $arg > input
	./minishell < input > output
done

awk 'NR==FNR{a[$0]=1;next}!a[$0]' output hp > p
awk 'NR==FNR{a[$0]=1;next}!a[$0]' hp output > pc
sed "s/$(cat p)//" pc



rm testfile
rm a
rm p
rm hp
rm pc
rm input
rm output
