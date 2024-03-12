#!/bin/bash

echo "Sorting the superlist and removing the bak file"
sort-uniq api-superlist-small.txt && rm api-superlist-small.txt.bak

echo "Adding to medium list, sorting the medium list and removing the bak file"
cat api-superlist-small.txt >> api-medium.txt && \
	sort-uniq api-medium.txt && \
	rm api-medium.txt.bak

echo "Adding to large list, sorting the large list and removing the bak file"
cat api-medium.txt >> api-large.txt && \
	sort-uniq api-large.txt && \
	rm api-large.txt.bak

