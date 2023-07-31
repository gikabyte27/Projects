#!/bin/bash

# The following command should be treated as a template
hashcat -m 0 -a 0 hashes.txt wordlist.txt --status -w 3 --debug-mode=1 --debug-file=stats.txt -o results.txt --potfile=disable -r rule.rule
