#!/bin/bash

set -xe

domain=$1
base=$2
mail=$3
uid=$4
gid=$5
cert='/etc/letsencrypt/live/upadhyay.xyz/fullchain.pem'
key='/etc/letsencrypt/live/upadhyay.xyz/privkey.pem'

user[0]='ravi'          ; password[0]='{SHA256-CRYPT}$5$/qCfODgHZrPfhCEk$uv4CQ4ytl2ZnpA0/ExZEZOgMnq9b.W0/nlGhxuY.eu3'
user[1]='shambhavi'     ; password[1]='{SHA256-CRYPT}$5$EObhy6eBVoHGPLCs$08vhwR9pCPzDFbTMw3yfkVzbTI/SFcUYhmC.wsS.tcC'

for i in {0..1}
do
    u=${user[i]}
    p=${password[i]}
    echo "$u@$domain $u/$mail/" >> ./postfix/vmailbox
    echo "$u@$domain $u" >> ./postfix/senders
    echo "$u:$p:$uid:$gid::$base/$u" >> ./dovecot/passwd
done

echo "@$domain ravi/$mail/" >> ./postfix/vmailbox
echo "@$domain ravi" >> ./postfix/senders

sed -i "s:REPLACE_CERT:$cert:g" ./postfix/main.cf
sed -i "s:REPLACE_KEY:$key:g" ./postfix/main.cf
sed -i "s:REPLACE_DOMAIN:$domain:g" ./postfix/main.cf
sed -i "s:REPLACE_BASE:$base:g" ./postfix/main.cf
sed -i "s:REPLACE_UID:$uid:g" ./postfix/main.cf
sed -i "s:REPLACE_GID:$gid:g" ./postfix/main.cf
sed -i "s:REPLACE_MAILDIR:$mail:g" ./dovecot/dovecot.conf
sed -i "s:REPLACE_CERT:$cert:g" ./dovecot/dovecot.conf
sed -i "s:REPLACE_KEY:$key:g" ./dovecot/dovecot.conf

cp postfix/main.cf /etc/postfix/main.cf
cp postfix/master.cf /etc/postfix/master.cf
cp postfix/vmailbox /etc/postfix/vmailbox
postmap /etc/postfix/vmailbox
cp postfix/senders /etc/postfix/senders
postmap /etc/postfix/senders
cp dovecot/dovecot.conf /etc/dovecot/dovecot.conf
cp dovecot/passwd /etc/dovecot/passwd
