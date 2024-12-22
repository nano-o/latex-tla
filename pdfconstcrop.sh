#!/bin/sh

# This calculates a bounding box that works for all pages and then crops them all using this single bounding box

pdfcrop --bbox "$(
    pdfcrop --verbose "$@" |
    grep '^%%HiResBoundingBox: ' |
    cut -d' ' -f2- |
    LC_ALL=C datamash -t' ' min 1 min 2 max 3 max 4
)" "$@"

