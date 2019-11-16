#!/bin/bash

# when I create a new markdown file it is not automatically added to SUMMARY.md which is
# relevant for the table of contents (TOC)
for f in `find .. -mindepth 1 -maxdepth 1 -name "*.md"`; do
    fs=`echo $f | awk -F "/" '{printf "%s\n",$NF;}'`
    grep $fs ../SUMMARY.md > /dev/null
    if [ ! "$?" = "0" ]; then 
        echo $fs
    fi
done