#!/bin/fish

argparse --name=(status basename) -i --min-args=1 'f/format=?' 'o/output=?' -- $argv
or exit 1

if test \( -z "$_flag_format" \) -o \( 'binary' = "$_flag_format" \)
    set format 'binary' '-dannotated=false'
    set extension 'bin'
else if test "$_flag_format" = 'symbols'
    set format 'symbols' '-dannotated=false'
    set extension 'sym'
else if test "$_flag_format" = 'tcgame'
    set format 'tcgame,group:8' '-dannotated=true'
    set extension 'ann'
else if test "$_flag_format" = 'annotated'
    set format 'annotated,group:8' '-dannotated=true'
    set extension 'ann'
else
    echo "Unsupported format: $_flag_format"
    echo 'Supported formats are: binary, tcgame, or annotated'
    exit 1
end

if test "$_flag_output" = '--'
    set output "--print"
else if test -n "$_flag_output"
    set output "--output=$_flag_output"
else if test (count $argv) = 1
    set new_name (path change-extension $extension $argv)
    set output "--output=$new_name"
else
    set output "out.$extension"
end

set argc (count $argv)
for idx in (seq $argc)
    set arg $argv[$idx]
    if test -e "$arg"
        ./parse_alias.py < "$arg" > "$arg.tmp"
        set argv[$idx] "$arg.tmp"
    end
end

customasm -f $format $output $argv

rm *.tmp
