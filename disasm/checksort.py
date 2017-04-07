#!/usr/bin/python

import sys, re

reD4   = re.compile('^\.\(d4 0x([0-9a-fA-F]+)')
reDS   = re.compile('^\.\(ds 0x([0-9a-fA-F]+)')
reDV   = re.compile('^\.\(dv 0x([0-9a-fA-F]+)')
reFUNC = re.compile('^\.\(func 0x([0-9a-fA-F]+)')
reCCA  = re.compile('^\.CCa 0x([0-9a-fA-F]+)')
reF    = re.compile('^f\s+\S+\s+@\s+0x([0-9a-fA-F]+)')

lastaddr = "00000000"
line = 0
lines = {}

def checkaddr(m):
	global lastaddr, lines
	addr = m.group(1).lower()
	while len(addr) < 8:
		addr = "0" + addr
	# print addr, line
	s = "wrong order"
	if addr < lastaddr:
		# print "ADDR:", addr
		# print "LAST:", lastaddr
		ll = lines.keys()
		ll.sort()
		# print ll
		for l in ll:
			# print "check", addr, "against", l, lines[l]
			if l > addr:
				print "%s:%d: wrong line" % (sys.argv[1], line)
				print "%s:%d: put before this" % (sys.argv[1], lines[l])
				exit(1)
		#print l
	else:
		lines[addr] = line
	lastaddr = addr

for s in open(sys.argv[1]).readlines():
	line += 1
	m = reFUNC.match(s)
	if m:
		checkaddr(m)
		continue

	m = reD4.match(s)
	if m:
		checkaddr(m)
		continue

	m = reDS.match(s)
	if m:
		checkaddr(m)
		continue

	m = reDV.match(s)
	if m:
		checkaddr(m)
		continue

	m = reCCA.match(s)
	if m:
		checkaddr(m)
		continue

	m = reF.match(s)
	if m:
		if s.find("entry0") == -1:
			checkaddr(m)
		continue
