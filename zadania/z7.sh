#! /usr/local/bin/bash2
#
# Meno: Stevuliak Marek, kr. 6
# Kruzok: 06
# Datum: pripravne_csh (id: 7)
# Zadanie: zadanie24
#
# Text zadania:
#
# V zadanych adresaroch uvedenych ako argumenty najdite textove subory,
# v ktorych obsahu sa vyskytuje ich meno. Prehladavajte vsetky zadane adresare
# a aj ich podadresare.
# Ak nebude uvedena ako argument ziadna cesta, prehladava sa aktualny pracovny
# adresar (teda .).
# Ak bude skript spusteny s prepinacom d <hlbka>, prehlada adresare len do
# hlbky <hlbka> (vratane). Hlbka znamena pocet adresarov na ceste medzi
# startovacim adresarom a spracovavanym suborom. Hlbka 1 znamena, ze bude
# prezerat subory len v priamo zadanych adresaroch.
#
# Syntax:
# zadanie1.csh [h][d <hlbka>] [cesta ...]
#
# Vystup ma tvar:
# Output: '<cesta k najdenemu suboru> <pocet riadkov s menom suboru>'
#
# Priklad vystupu:
# Output: '/home/OS/test/test1/123/deviaty 19'
#
# Program musi osetrovat pocet a spravnost argumentov. Program musi mat help,
# ktory sa vypise pri zadani argumentu -h a ma tvar:
# Meno programu (C) meno autora
#
# Usage: <meno_programu> <arg1> <arg2> ...
#    <arg1>: xxxxxx
#    <arg2>: yyyyy
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
set -o noglob

while [ $# -gt 0 ]; do
  case $1 in
        -h)
           echo "zadanie24 id7 (C) Stevuliak Marek"
           echo "Usage: $0 -h -d [hlbka]"
           echo "-h: Prints help"
           echo "-d [depth]: sets depth of searching"
           exit 0;
           ;;
        -d)
           shift
           if [ $# -eq 0 ]; then
             echo "Error: 'parameter -d must be followed be a number'" 2>/dev/stderr
             exit 1
           else
             if [ $1 -ge 0 2>/dev/null ]; then
               depth="$1"
               shift
               break
             else
               echo "Error: 'Bad number format'" 2>/dev/stderr
               exit 1
             fi
           fi
           ;;
        -*)
           echo "Error: 'Unexpected argument'" 2>/dev/stderr
           exit 1
           ;;
         *)
           break;
           ;;
   esac
done
IFS="
"

if [ $# -eq 0 ]; then
   if [ $depth -gt 0 ]; then
     files=( `find . -maxdepth $depth -type f -exec file {} \; | grep "text$" | rev | cut -d ":" -f2- | rev` )
   else
     files=( `find . -type f -exec file {} \; | grep "text$" | rev | cut -d ":" -f2- | rev` )
   fi

   i=$(( ${#files[@]} - 1 ))
   while [ $i -ge 0 ]; do
     name="`echo "${files[$i]}" | rev | cut -d "/" -f1 | rev`"
     count=`grep -Fc "$name" "${files[$i]}" 2>/dev/null`
     if [ $count -gt 0 2>/dev/null ]; then
       echo -n "Output: '"; echo ""${files[$i]}" $count'"
     fi
     i=$(( $i - 1 ))
   done
fi

while [ $# -gt 0 ]; do

    if [ $depth -ge 0 ]; then
     files=( `find "$1" -maxdepth $depth -type f -exec file {} \; | grep "text$" | rev | cut -d ":" -f2- | rev` )
   else
     files=( `find "$1" -type f -exec file {} \; | grep "text$" | rev | cut -d ":" -f2- | rev` )
   fi


   i=$(( ${#files[@]} - 1 ))

   while [ $i -ge 0 ]; do
     name="`echo "${files[$i]}" | rev | cut -d "/" -f1 | rev`"
     count=`grep -Fc "$name" "${files[$i]}" 2>/dev/null`
     if [ $count -gt 0 2>/dev/null ]; then
       echo -n "Output: '"; echo ""${files[$i]}" $count'"
     fi
     i=$(( $i - 1 ))
   done
   shift
done
exit 0
#grepy som podaval na stderr, naprd expanzia