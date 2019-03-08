#!/usr/bin/env python3
import git
import sys

if(len(sys.argv) != 2):
    print('usage: pullRepo.py repos.txt')
    exit(0)

file = open(sys.argv[1])

lines = file.read().split('\n')
lines.pop()

for l in lines:
    dir = l.split('/')
    dir = dir[-1].split('.')
    dir = dir[0]
    print(dir)
    repo = git.Repo(dir)
    o = repo.remotes.origin
    o.pull()
