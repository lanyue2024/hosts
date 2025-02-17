#!/bin/bash

file="hosts.txt"
tmpfile=$(mktemp)
dnsmasq="dnsmasq.conf"
adguardhome="adguardhome.txt"
adguardhome100="adguardhome100.txt"
t=$(date)

if [ -f "$file" ]; then
    echo "# $t" >$dnsmasq
    echo "" >>$dnsmasq
    echo "address=/sniproxy.local/IP" >>$dnsmasq
    echo "" >>$dnsmasq

    echo "# $t" >$adguardhome
    echo "" >>$adguardhome

    echo "# $t" >$adguardhome100
    echo "" >>$adguardhome100

    cat $file |tr -d '[:blank:]'|sort -u |egrep -v '^#|^$' >$tmpfile
    while IFS='' read -r line; do
        echo "cname=${line},sniproxy.local,10" >>$dnsmasq
        echo "||${line}^\$dnsrewrite=sniproxy.local" >>$adguardhome
        echo "||${line}^\$client=100.0.0.0/8,dnsrewrite=sniproxy100.local" >>$adguardhome100
    done < "$tmpfile"
fi

rm $tmpfile

