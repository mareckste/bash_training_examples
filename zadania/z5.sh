#! /usr/local/bin/bash2
#
# Meno: Stevuliak Marek, kr. 6
# Kruzok: 06
# Datum: pripravne_csh (id: 5)
# Zadanie: zadanie21
#
# Text zadania:
#
# Zistite, ktori pouzivatelia sa hlasia na osu z viac ako 10tich roznych
# strojov za poslednu dobu (odkedy system zaznamenava tieto informacie).
# Ak bude skript spusteny s parametrom n <pocet>, zistite, ktory pouzivatelia
# sa hlasia z viac ako <pocet> strojov.
# Ignorujte prihlasenia, pre ktore nepoznate adresu stroja.
# Pomocka: pouzite prikaz last
#
# Syntax:
# zadanie1.csh [h][n <pocet>]
#
# Format vypisu bude nasledovny:
# Output: '<meno pouzivatela> <pocet roznych strojov, z ktorych sa hlasil>'
#
# Priklad vystupu:
# Output: 'staron 25'
# Output: 'gorner 24'
# Output: 'bisco 23'
#
#
# Program musi osetrovat pocet a spravnost argumentov. Program musi mat help,
# ktory sa vypise pri zadani argumentu h
#a ma tvar:
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
# Debug: vypis ...
#
# Poznamky: (sem vlozte pripadne poznamky k vypracovanemu zadaniu)
#
# Riesenie:
n=-1
if [ $# -gt 0 ]; then
  case $1 in
    -h)
        echo "Meno Priezvisko Copyright Zadanie id 5"
        echo "Usage: $0 -h -n[pocet]"
        echo "-h: help"
        echo "-n: pocet strojov"
        exit 0
        ;;
    -n)
        if [ $2 -ge 0 2>/dev/null ]; then
          n="$2"
        else
          echo "Error: 'Bad number format'" 2>/dev/stderr
          exit 1
        fi
        ;;
     *)
        echo "Error: 'Bad input, check help for further info'" 2>/dev/stderr
        exit 1
        ;;
   esac
fi

IFS='
'
pocty=( `last | grep tty | tr -s " " "/" | grep -E "(.*/.*){9}" | tr "/" " " | sort | cut -d " " -f1,3 | sort | uniq | cut -d " " -f1 | uniq -c | sort -n | tr -s " " | cut -d " " -f2` )
ludia=( `last | grep tty | tr -s " " "/" | grep -E "(.*/.*){9}" | tr "/" " " | sort | cut -d " " -f1,3 | sort | uniq | cut -d " " -f1 | uniq -c | sort -n | tr -s " " | cut -d " " -f3` )

i=$(( ${#pocty[@]} - 1 ))

if [ $n -lt 0 ]; then
  n=10
fi

while [ $i -ge 0 ]; do
  if [ ${pocty[$i]} -gt $n ]; then
    echo -n "Output: '"; echo "${ludia[$i]} ${pocty[$i]}'"
  fi
  i=$(( $i - 1 ))
done
exit 0