#!/bin/bash

set -e

tmp_cv=/tmp/cv.rst
cp cv.rst $tmp_cv

# today
sed -i -e "s#DATE_KKK#$(date +%d-%m-%Y)#g" $tmp_cv

# my age
birth=$(date -d "1988-11-19" +%s)
today=$(date +%s)
seconds_in_year=$((3600*24*365))
age=$((($today-$birth)/seconds_in_year))
sed -i -e "s#AGE_KK#$age ans#g" $tmp_cv

generate_timeline()
{
    name="$1"
    ./Timeline/make_timeline.py $name.json > $name.svg
    rsvg-convert $name.svg -w 10000 > $name.png
    convert $name.png -background white -flatten -quality 80% -crop 2x1@ +repage $name%02d.jpg
    cp "$name"00.jpg /tmp
    cp "$name"01.jpg /tmp
}

#Timeline: https://github.com/jasonreisman/Timeline
#rsvg-convert: debian package librsvg2-bin
generate_timeline cv_timeline

# final generation
rst2pdf $tmp_cv -s cv.style -o cv.pdf
rst2html $tmp_cv > cv.html
