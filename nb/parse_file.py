#!/usr/bin/python

import fileinput

full_line = ''
for line in fileinput.input():
  full_line += ' ' + line.strip()
print full_line
