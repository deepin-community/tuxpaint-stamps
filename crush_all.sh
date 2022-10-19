#!/bin/sh

for i in `find stamps -name "*.png"`
do
  ls -l $i

  #rm tmp.png 2> /dev/null

  pngout -q $i
# 2>&1 > /dev/null

  #mv tmp.png $i 2> /dev/null

  ls -l $i

  echo ------------------------------------------------------------------------------
done

