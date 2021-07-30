domain := upadhyay.xyz
admin  := ravi

setup: create-linux-users
setup: create-email-accounts
setup: replace-variables
setup: create-directories
setup: copy-files
setup: opendkim-key

create-linux-users:
	groupadd -g 2000 virtualmail || true
	useradd -g virtualmail -u 2000 virtualmail -d /home/virtualmailboxes -m || true
	usermod -a -G virtualmail postfix
	gpasswd -a postfix opendkim

create-email-accounts:
	./add-user.sh $(domain) ravi '{SHA256-CRYPT}$5$/qCfODgHZrPfhCEk$uv4CQ4ytl2ZnpA0/ExZEZOgMnq9b.W0/nlGhxuY.eu3'
	./add-user.sh $(domain) shambhavi '{SHA256-CRYPT}$5$EObhy6eBVoHGPLCs$08vhwR9pCPzDFbTMw3yfkVzbTI/SFcUYhmC.wsS.tcC'

replace-variables:
	sed -i "s:REPLACE_DOMAIN:$(domain):g" postfix/* dovecot/* opendkim/* mailname
	sed -i "s:REPLACE_ADMIN:$(domain):g" postfix/* dovecot/* opendkim/* mailname

create-directories:
	mkdir -p /home/virtualmailboxes/$(domain)
	mkdir -p /var/spool/postfix/opendkim
	mkdir -p /etc/opendkim
	mkdir -p /etc/opendkim/keys
	mkdir -p /etc/opendkim/keys/$(domain)
	chown -R virtualmail:virtualmail /home/virtualmailboxes
	chmod 770 /home/virtualmailboxes
	chown opendkim:postfix /var/spool/postfix/opendkim
	chown -R opendkim:opendkim /etc/opendkim
	chmod go-rw /etc/opendkim/keys

copy-files:
	cp mailname /etc/mailname
	cp postfix/main.cf /etc/postfix/main.cf
	cp postfix/master.cf /etc/postfix/master.cf
	cp postfix/vmailbox /etc/postfix/vmailbox
	postmap /etc/postfix/vmailbox
	cp postfix/senders /etc/postfix/senders
	postmap /etc/postfix/senders
	cp dovecot/dovecot.conf /etc/dovecot/dovecot.conf
	cp dovecot/passwd /etc/dovecot/passwd
	cp opendkim/opendkim.conf /etc/opendkim.conf
	cp opendkim/key.table /etc/opendkim/key.table
	cp opendkim/signing.table /etc/opendkim/signing.table
	cp opendkim/trusted.hosts /etc/opendkim/trusted.hosts

opendkim-key:
	opendkim-genkey -b 2048 -d $(domain) -D /etc/opendkim/keys/$(domain) -s default -v
	echo "Add a txt record with Name: default._domainkey and Body: v=DKIM1;k=rsa;p=<PUBLIC_KEY_GIVEN_BELOW>"
	cat /etc/opendkim/keys/$(domain)/default.txt

start:
	/usr/sbin/opendkim -x /etc/opendkim.conf
	postfix start
	/usr/sbin/dovecot -F

.PHONY: setup: create-linux-users create-email-accounts replace-variables create-directories copy-files opendkim-key
