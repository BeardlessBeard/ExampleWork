#!/usr/bin/env python3
import git
import sys

if(len(sys.argv) != 2):
    print('usage: cloneRepo.py repos.txt')
    exit(0)

file = open(sys.argv[1])

lines = file.read().split('\n')

lines.pop()
for l in lines:
    git.Git('./').clone(l)
