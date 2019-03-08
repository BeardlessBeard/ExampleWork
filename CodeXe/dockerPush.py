#!/usr/bin/env python3

import os
import sys

if(len(sys.argv) != 2):
    print('usage: python3 dockerPush.py student.txt')
    exit(0)

file = open(sys.argv[1], 'r')
lines = file.read().split('\n')
lines.pop()

for student in lines:
    student = student.split()
    fname = student[0]
    lname = student[1]
    dir = 'CodeXe_' + fname + '_' + lname + '/lab1/'
    dockername = fname.lower() + '_lab1'
    os.system('docker build -t ' + dockername + ' ' + dir)
    os.system('docker tag ' + dockername + ' beardlessbeard/' + dockername)
    os.system('docker push beardlessbeard/' + dockername)
