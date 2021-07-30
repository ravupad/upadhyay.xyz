#!/bin/bash

set -xe

domain=$1
user=$2
password=$3

echo "$user@$domain $user/Maildir/" >> ./postfix/vmailbox
echo "$user@$domain $user" >> ./postfix/senders
echo "$user:$password:2000:2000::/home/virtualmailboxes/$user" >> ./dovecot/passwd

