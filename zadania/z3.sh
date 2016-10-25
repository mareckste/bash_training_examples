#! /usr/local/bin/bash2
#
# Meno: Stevuliak Marek, kr. 6
# Kruzok: 06
# Datum: pripravne_csh (id: 3)
# Zadanie: zadanie16
#
# Text zadania:
#
# Vypiste vsetkych pouzivatelov, ktori neboli za poslednu dobu (odkedy system
# zaznamenava tieto informacie) prihlaseni.
# Ak bude skript spusteny s prepinacom -g <group>, vypise len pouzivatelov,
# ktori neboli za poslednu dobu prihlaseni a patria do skupiny <group>, ktora
# je zadana ako cislo.
# Pomocka: pouzite prikaz last a informacie z /etc/passwd.2001.
#
# Syntax:
# zadanie1.csh [-h] [-g <group>]
#
# Format vypisu bude nasledovny:
# Output: '<login_name> <group> <full_name>'
#
# Priklad vystupu:
# Output: 'cernicka 520 Cernicka Martin'
# Output: 'chudik 520 Chudik Alexander'
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
showGuide () {
        echo "$0 (C) Marek Stevuliak"
        echo ""
        echo "Usage: $0 [-h] [-g <group ID>]"
        echo ""
        echo "-h:    shows user's guide"
        echo "-g <group number> :     prints users of current group"
        exit 0
}

findGroup () {
        IFS='
'
        results=""
        last=( "`last | grep tty | cut -d " " -f1 | sort | uniq`" )
        paswd="`tr -s " " < /etc/passwd.2001 | cut -d ":" -f1,4,5 | cut -d "," -f1 | tr ":" " "`"


        for k in ${last[@]}
        do
             if [ $# -eq 0 ] ; then
                result="`echo "$paswd" | grep -vE "^"$k"[[:space:]]"`"
             else
                result="`echo "$paswd" | grep -vE "^"$k"[[:space:]]" | grep "[[:space:]]$1[[:space:]]"`"
             fi
             paswd="$result";
        done

        array=("$result")

        for u in ${array[@]}
        do
                echo -n "Output: '"
                echo -n "$u"
                echo "'"
        done

        exit 0;
}

if [ $# -gt 2 ] ; then
      >&2 echo "Error: Too many arguments"
      exit 1
else
    if [ $# -eq 0 ] ; then
         echo -n ""
         findGroup
    else
          case $1 in
          -h)
                showGuide
                ;;
          -g)   #sem dam hladanie podla skupiny
                if [ "$2" -ge 0 2>/dev/null ] ; then
                      findGroup $2
                else
                    >&2 echo "Error: You must insert a correct number"
                    exit 1
                fi
                ;;

          -*)
                >&2 echo "Error: Unexpected argument"
                exit 1
                ;;
           *)   >&2 echo "Error: Invalid input"
                exit 1
                ;;
          esac

    fi
fi