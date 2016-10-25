#! /usr/local/bin/bash2
#
# Meno: Stevuliak Marek, kr. 6
# Kruzok: 06
# Datum: pripravne_csh (id: 4)
# Zadanie: zadanie17
#
# Text zadania:
#
# V zadanych adresaroch uvedenych ako argumenty najdite symbolicke linky,
# ktorych cielova cesta ma zo vsetkych najviac komponentov - to znamena, ze sa
# na ceste k cielovemu suboru nachadza najviac adresarov. Prehladavajte vsetky
# zadane adresare a aj ich podadresare.
# Ak nebude uvedena ako argument ziadna cesta, prehladava sa aktualny pracovny
# adresar (teda .).
# Ak bude skript spusteny s prepinacom -d <hlbka>, prehlada adresare len do
# hlbky <hlbka> (vratane). Hlbka znamena pocet adresarov na ceste medzi
# startovacim adresarom a spracovavanym suborom. Hlbka 1 znamena, ze bude
# prezerat subory len v priamo zadanych adresaroch.
#
# Syntax:
# zadanie1.csh [-h] [-d <hlbka>] [cesta ...]
#
# Vystup ma tvar:
# Output: '<cesta k najdenej linke> -> <cielova cesta>'
#
# Priklad vystupu:
# Output: 'test5/lev1_2/lev2_2/symlink_4 -> ../../lev1_1/lev2_1/testfile_17'
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
# Debug: vypis ...
#
# Poznamky: (sem vlozte pripadne poznamky k vypracovanemu zadaniu)
#
# Riesenie:
depth=-1
while [ $# -gt 0 ]; do
   case $1 in
     -h)
          echo "Name and Surname C  id. 4"
          echo "Usage: <"$0"> <-h> <-d [depth]> <cesta> ..."
          echo "<-h>: help"
          echo "<-d [cislo]>: max hlbka"
          exit 0
     ;;
     -d)
          shift
          if [ $# -eq 0 ] ; then
            echo "Error: 'Zly vstup'" >/dev/stderr
            exit 1
          fi

          if [ "$1" -ge 0 2>/dev/null ] ; then
            depth="$1"
            shift
            break
          else
            echo "Error: 'Bad number format'" >/dev/stderr
            exit 1
          fi
     ;;
     -*)  echo "Error: 'Bad argument'" >/dev/stderr
          exit 1
     ;;
     *) #pokracujeme
        break
     ;;
   esac
done

adr=( "" )
max=0
IFS='
'

#ak hladam bez udanej cesty
if [ $# -eq 0 ]; then
   if [ $depth -ge 0 ]; then
       adr=( `find . -maxdepth $depth -type l -printf '%p -> %l\n' 2>/dev/null` )
   else
       adr=( `find . -type l -printf '%p -> %l\n' 2>/dev/null` )
   fi
   i=$(( ${#adr[@]} - 1 ))
   while [ "$i" -ge 0 ]; do
     poc=`echo "${adr[$i]}" | cut -d ">" -f2 | tr -cd "/" | wc -c | tr -d " "`
     if [ "$poc" -gt "$max" ]; then

        max="$poc"
     fi
     i=$(( $i - 1 ))
   done

   i=$(( ${#adr[@]} - 1 ))
   while [ "$i" -ge 0 ]; do
     poc=`echo "${adr[$i]}" | cut -d ">" -f2 | tr -cd "/" | wc -c | tr -d " "`
     if [ "$poc" -eq "$max" ]; then
        echo -n "Output: '"
        echo "${adr["$i"]}'"
     fi
     i=$(( $i - 1 ))
   done
fi
#ak som zadal cestu
while [ $# -gt 0 ]; do
   if [ $depth -ge 0 ]; then
       adr=( `find $1 -maxdepth $depth -type l -printf '%p -> %l\n' 2>/dev/null` )
   else
       adr=( `find $1 -type l -printf '%p -> %l\n' 2>/dev/null` )
   fi
   i=$(( ${#adr[@]} - 1 ))
   while [ "$i" -ge 0 ]; do
     poc=`echo "${adr[$i]}" | cut -d ">" -f2 | tr -cd "/" | wc -c | tr -d " "`
     if [ "$poc" -gt "$max" ]; then
        max="$poc"
     fi
     i=$(( $i - 1 ))
   done

   i=$(( ${#adr[@]} - 1 ))
   while [ "$i" -ge 0 ]; do
     poc=`echo "${adr[$i]}" | cut -d ">" -f2 | tr -cd "/" | wc -c | tr -d " "`
     if [ "$poc" -eq "$max" ]; then
        echo -n "Output: '"
        echo  "${adr["$i"]}'"
     fi
     i=$(( $i - 1 ))
   done
  shift
done

exit 0