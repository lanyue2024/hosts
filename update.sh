#!/bin/bash

file="hosts.txt"
tmpfile=$(mktemp)
dnsmasq="dnsmasq.conf"
adguardhome="adguardhome.txt"
t=$(date)

if [ -f "$file" ]; then
    echo "# $t" >$dnsmasq
    echo "" >>$dnsmasq
    echo "address=/sniproxy.local/IP" >>$dnsmasq
    echo "" >>$dnsmasq

    echo "# $t" >$adguardhome
    echo "" >>$adguardhome

    cat $file |tr -d '[:blank:]'|sort -u |egrep -v '^#|^$' >$tmpfile
    while IFS='' read -r line; do
        echo "cname=${line},sniproxy.local,10" >>$dnsmasq
        echo "||${line}^\$dnsrewrite=sniproxy.local" >>$adguardhome
    done < "$tmpfile"
fi

rm $tmpfile

