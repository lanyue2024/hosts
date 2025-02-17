#!/bin/bash

IP="100.85.41.5"
file="hosts.txt"
tmpfile=$(mktemp)
dnsmasq="dnsmasq.conf"
adguardhome="adguardhome.txt"
adguardhome100="adguardhome100.txt"
t=$(date)

if [ -f "$file" ]; then
    echo "# $t" >$dnsmasq
    echo "" >>$dnsmasq

    echo "# $t" >$adguardhome
    echo "" >>$adguardhome

    echo "# $t" >$adguardhome100
    echo "" >>$adguardhome100

    cat $file |tr -d '[:blank:]'|egrep -v '^#|^$' >$tmpfile
    while IFS='' read -r line; do
        echo "address=/${line}/$IP" >>$dnsmasq
        echo "||${line}^\$dnsrewrite=$IP" >>$adguardhome
        echo "||${line}^\$client=100.0.0.0/8,dnsrewrite=$IP" >>$adguardhome100
    done < "$tmpfile"
fi

rm $tmpfile

