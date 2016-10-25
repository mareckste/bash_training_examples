#! /usr/local/bin/bash2
#
# Meno: Stevuliak Marek, kr. 6
# Kruzok: 06
# Datum: pripravne_csh (id: 1)
# Zadanie: zadanie01
#
# Text zadania:
#
# V zadanych adresaroch uvedenych ako argumenty najdite adresare, v ktorych
# je suma poctov riadkov vsetkych obycajnych suborov najvacsia. Prehladavajte
# vsetky zadane adresare a aj ich podadresare. Sumy pocitajte len pre subory,
# ktore su priamo v adresari.
# Ak nebude uvedena ako argument ziadna cesta, prehladava sa aktualny pracovny
# adresar (teda .).
# Ak bude skript spusteny s prepinacom w, najde adresare, v ktorych je suma
# poctov slov obycajnych suborov najvacsia.
# Ak bude skript spusteny s prepinacom c, najde adresare, v ktorych je suma
# poctov znakov obycajnych suborov najvacsia.
#
# Syntax:
# zadanie1.csh [h] [c] [w] [cesta ...]
#
# Vystup ma tvar:
# Output: '<cesta k najdenemu adresaru> <celkovy pocet riadkov>'
#
# Priklad vystupu (zadanie1.csh /home/OS ucebnove):
# Output: '/home/OS/bin 30'
# Output: '/home/OS/pocitacove 30'
# Output: '/ucebnove/1 30'
#
#
# Program musi osetrovat pocet a spravnost argumentov. Program musi mat help,
# ktory sa vypise pri zadani argumentu h a ma tvar:
# Meno programu (C) meno autora
#
# Usage: <meno_programu> <arg1> <arg2> ...
# <arg1>: xxxxxx
# <arg2>: yyyyy
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

p="-l"
set -o noglob
while [ $# -gt 0 ]; do
    case $1 in

        -h) echo "Usage: ... "
            exit 0;
            ;;
        -c)
            p="-c"
            shift
            break
            ;;
        -w)
            p="-w"
            shift
            break
            ;;
        -*) echo "Error: '...'" 2>/dev/stderr
            exit 1
            ;;
        *)  break
           ;;
    esac
done

max=0
IFS='
'
list=( "" )


if [ $# -eq 0 ]; then

   dirs=( `find . -type d 2>/dev/null` )
   i=$(( ${#dirs[@]} - 1 ))
        while [ $i -ge 0 ]; do
           nums=( `find  "${dirs[$i]}" -maxdepth 1 -type f -exec wc "$p" {} 2>/dev/null \; 2>/dev/null | tr -s " " | cut -d " " -f2` )
           count=0
           j=$(( ${#nums[@]} - 1 ))

           while [ $j -ge 0 ]; do
             count=$(( $count + ${nums[$j]} ))
             j=$(( $j - 1 ))
           done
           if [ $count -gt $max ]; then
             max="$count"
             list=( "${dirs[$i]} $count" )
           else
                if [ $count -eq $max ]; then
                   list=( "${list[@]}" "${dirs[$i]} $count" )
                fi
           fi
           i=$(( $i - 1 ))
        done
fi

while [ $# -gt 0 ]; do

   dirs=( `find "$1" -type d 2>/dev/null` )
   i=$(( ${#dirs[@]} - 1 ))
        while [ $i -ge 0 ]; do
           nums=( `find  "${dirs[$i]}" -maxdepth 1 -type f -exec wc "$p" {} 2>/dev/null \; 2>/dev/null | tr -s " " | cut -d " " -f2` )
           count=0
           j=$(( ${#nums[@]} - 1 ))
           while [ $j -ge 0 ]; do
             count=$(( $count + ${nums[$j]} ))
             j=$(( $j - 1 ))
           done
           if [ $count -gt $max ]; then
             max="$count"
             list=( "${dirs[$i]} $count" )
           else
                if [ $count -eq $max ]; then
                   list=( "${list[@]}" "${dirs[$i]} $count" )
                fi
           fi
           i=$(( $i - 1 ))
        done
        shift

done

j=$(( ${#list[@]} - 1 ))
while [ $j -ge 0 ]; do
  echo -n "Output: '"${list[$j]}""; echo "'"
  j=$(( $j - 1 ))
done
exit 0