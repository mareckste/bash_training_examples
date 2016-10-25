#! /usr/local/bin/bash2
#
# Meno: Stevuliak Marek, kr. 6
# Kruzok: 06
# Datum: pripravne_csh (id: 2)
# Zadanie: zadanie14
#
# Text zadania:
#
# V zadanych textovych suboroch uvedenych ako argumenty najdite najdlhsi riadok
# (riadky) zo vsetkych a vypiste ho (ich). Dlzka riadku je jeho dlzka v znakoch.
# Ak nebude uvedeny ako argument ziadny subor, prehladava sa standardny vstup
# (a jeho meno je -).
#
# Syntax:
# zadanie1.csh [-h] [cesta ...]
#
# Vystup ma tvar:
# Output: '<subor>: <cislo riadku v subore> <dlzka riadku> <riadok>'
#
# Priklad vystupu (parametrami boli subory 123/deviaty druhy/meno/nejaky
# v adresari /home/OS/test/test1):
# Output: '123/deviaty: 1 178 6subor jednoducho... 123 subo2r ...'
# Output: '123/deviaty: 36 178 6subor jednoducho... 123 subo2r ...'
# Output: 'druhy/meno/nejaky: 14 178 nejaky stvrty jednoducho... semtam stvrty ...'
#
#
# Program musi osetrovat pocet a spravnost argumentov. Program musi mat help,
# ktory sa vypise pri zadani argumentu -h a ma tvar:
# Meno programu (C) meno autora
#
# Usage: <meno_programu> <arg1> <arg2> ...
#       <arg1>: xxxxxx
#       <arg2>: yyyyy
#
# Parametre uvedene v <> treba nahradit skutocnymi hodnotami.
# Ked ma skript prehladavat adresare, tak vzdy treba prehladat vsetky zadane
# adresare a vsetky ich podadresare do hlbky.
# Pri hladani maxim alebo minim treba vzdy najst maximum (minimum) vo vsetkych
# zadanych adresaroch (suboroch) spolu. Ked viacero suborov (adresarov, ...)
# splna maximum (minimum), treba vypisat vsetky.
#
# Korektny vystup programu musi ist na standardny vystup (stdout).
# Chybovy vystup programu by mal ist na chybovy vystup (stderr).
# Chybovy vystup musi mat tvar (vratane apostrofov):
# Error: 'adresar, subor, ... pri ktorom nastala chyba': popis chyby ...
# Ak program pouziva nejake pomocne vypisy, musia mat tvar:
# Debug: vypis .
#
# Poznamky: (sem vlozte pripadne poznamky k vypracovanemu zadaniu)
#
# Riesenie:
set -o noglob
while [ $# -gt 0 ]; do
  case $1 in
        -h)
           echo "Stevuliak Marek (C) zadanie id2"
           echo "Usage: $0 <-h> <files>"
           echo "-h: prints guide"
           echo "files: Finds the longest line of the file and prints the filename, index, no. of chars and its content"
           exit 0
        ;;

        -*) echo "Error: 'Bad argument'" 2>/dev/null
            exit 1
        ;;

        *) break
        ;;
   esac
done

IFS='
'

max=0
lines=( "" )

count=0
if [ $# -eq 0 ]; then
  while [ 1 -eq 1 ]; do
     read input
     count=$(( $count + 1 ))
     chars=`echo -n "$input" | wc -c | tr -d " "`
     if [ $chars -eq 0 ]; then
        break
     else
        if [ $chars -gt $max ]; then
           max=$chars
           lines=( "-: $count $chars "$input"" )
           continue
        fi
        if [ $chars -eq $max ]; then
           lines=( "${lines[@]}" "-: $count $chars "$input"" )
        fi
     fi
   done
fi

while [ $# -gt 0 ]; do
   check=`file "$1" | grep -c "text$"`
   if [ $check -eq 0 ]; then
     echo "Error: 'parameter is not a text file'"
     exit 1
   fi
   count=`wc -l < "$1" 2>/dev/null | tr -d " " 2>/dev/null`
   while [ $count -gt 0 ]; do
        line=`head -$count "$1" 2>/dev/null | tail -1 2>/dev/null`
        chars=`echo -n "$line"| wc -c | tr -d " "`
        if [ $chars -gt $max ]; then
           max=$chars
           lines=( ""$1": $count $chars "$line"" )
           count=$(( $count - 1 ))
           continue
        fi
        if [ $chars -eq $max ]; then
           #echo "Debug: pridavam $chars"
           #echo "Debug: "$1": $count $chars "$line""
           lines=( "${lines[@]}" ""$1": $count $chars "$line"" )
        fi
        count=$(( $count - 1 ))
   done
   shift
done

#vypis
count=$(( ${#lines[@]} - 1 ))
while [ $count -ge 0 ]; do
   echo -n "Output: '"; echo "${lines[$count]}'"
   count=$(( $count - 1 ))
done
exit 0