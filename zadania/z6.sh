#! /usr/local/bin/bash2
#
# Meno: Stevuliak Marek, kr. 6
# Kruzok: 06
# Datum: pripravne_csh (id: 6)
# Zadanie: zadanie23
#
# Text zadania:
#
# Zistite, ktori pouzivatelia sa hlasia na osu v noci (teda cas prihlasenia je
# od 22:00 do 05:00). Do uvahy berte len ukoncene spojenia za poslednu dobu
# (odkedy system zaznamenava tieto informacie).
# Ak bude skript spusteny s parametrom -n <pocet>, zistite, ktori pouzivatelia
# sa na osu prihlasili v noci viac ako <pocet> krat.
# Dodrzte format vystupu uvedeny v priklade.
# Pomocka: pouzite prikaz last
#
# Syntax:
# zadanie1.csh [-h] [-n <pocet>]
#
# Format vypisu bude nasledovny:
# Output: '<meno pouzivatela> <pocet nocnych prihlaseni> <datum a cas posledneho nocneho prihlasenia>'
#
# Priklad vystupu:
# Output: 'sedlacek 5 03-23 23:12'
# Output: 'tubel 2 03-23 22:55'
# Output: 'kubikm 4 03-23 02:31'
#
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
n=0
set -o noglob
if [ $# -gt 0 ]; then
   case $1 in
        -h)
            echo "Marek Stevuliak (C) id.6"
            echo "Usage: $0 <-h> <-n> [pocet]"
            echo "-h: prints help"
            echo "-n [pocet]: prints users that have logged in more then pocet"
            exit 0
            ;;
        -n)
                if [ $2 -ge 0 2>/dev/null ]; then
                  n=$2
                else
                   echo "Error: 'Neni to kladne cislo'"
                   exit 1
                fi
           ;;
        -*)
           echo "Error: 'Nespravny prepinac'" >/dev/stderr
           exit 1
           ;;
         *)
           echo "Error: 'Nespravny prepinac'" >/dev/stderr
           exit 1
           ;;
   esac
fi
IFS='
'


last="`last | grep tty | grep -Ev "still" | tr -s " " | grep -E "2[2-3]:..[ ]-|0[0-4]:..[ ]-|05:00[ ]-" | cut -d "(" -f1`"

mena=( `echo "$last" | cut -d " " -f1 | sort | uniq` )
i=$(( ${#mena[@]} - 1 ))
while [ $i -ge 0 ]; do
   pocet=`echo "$last" | grep -cw "${mena[$i]}"`
   mesiac="`echo "$last" | grep -w "${mena[$i]}" | rev | cut -d " " -f6 | head -1 | rev`"
   den="`echo "$last" | grep -w "${mena[$i]}" | rev | cut -d " " -f5 | head -1 | rev`"
   cas="`echo "$last" | grep -w "${mena[$i]}" | rev | cut -d " " -f4 | head -1 | rev`"

   if [ $den -lt 10 ]; then
	den="0$den"
   fi

   case "$mesiac" in
        Jan)
           mesiac=01
        ;;
        Feb)
           mesiac=02
        ;;
        Mar)
           mesiac=03
        ;;
        Apr)
           mesiac=04
        ;;
        May)
           mesiac=05
        ;;
        Jun)
           mesiac=06
        ;;
        Jul)
           mesiac=07
        ;;
        Aug)
           mesiac=08
        ;;
        Sep)
           mesiac=09
        ;;
        Oct)
           mesiac=10
        ;;
        Nov)
           mesiac=11
        ;;
        Dec)
           mesiac=12
        ;;
        *)
        ;;

   esac
   if [ $pocet -gt $n ]; then
        echo -n "Output: '"; echo ""${mena[$i]}" "$pocet" "$mesiac"-"$den" "$cas"'"
   fi
   i=$(( $i - 1 ))
done
exit 0