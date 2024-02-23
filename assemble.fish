#!/bin/fish

argparse --name=(status basename) -i --min-args=1 'f/format=?' 'o/output=?' -- $argv
or exit 1

if test \( -z "$_flag_format" \) -o \( 'binary' = "$_flag_format" \)
    set format 'binary' '-dannotated=false'
else if test "$_flag_format" = 'symbols'
    set format 'symbols' '-dannotated=false'
else if test "$_flag_format" = 'tcgame'
    set format 'tcgame,group:8' '-dannotated=true'
else if test "$_flag_format" = 'annotated'
    set format 'annotated,group:8' '-dannotated=true'
else
    echo "Unsupported format: $_flag_format"
    echo 'Supported formats are: binary, tcgame, or annotated'
    exit 1
end

if test "$_flag_output" = '--'
    set output "--print"
else if test -n "$_flag_output"
    set output "--output=$_flag_output"
else
    set output ""
end

if test -n "$output"
    customasm -f $format $output $argv
else
    customasm -f $format $argv
end
