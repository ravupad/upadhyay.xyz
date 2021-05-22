# setup: install
# setup: users
setup: dir
setup: stop
setup: configuration
setup: start

install:
	sudo apt-get install postfix
	sudo apt-get install dovecot-core dovecot-imapd

users:
	sudo groupadd -g 2000 virtualmail
	sudo useradd -g virtualmail -u 2000 virtualmail -d /home/virtualmailboxes -m
	sudo usermod -a -G virtualmail postfix

dir:
	sudo mkdir -p /home/virtualmailboxes/upadhyay.xyz
	sudo chown -R virtualmail:virtualmail /home/virtualmailboxes
	sudo chmod 770 /home/virtualmailboxes

stop:
	sudo postfix stop
	sudo systemctl stop dovecot.service

configuration:
	sudo cp postfix/main.cf /etc/postfix/main.cf
	sudo cp postfix/master.cf /etc/postfix/master.cf
	sudo cp postfix/virtual /etc/postfix/virtual
	sudo cp postfix/vmailbox /etc/postfix/vmailbox
	sudo postmap /etc/postfix/virtual
	sudo postmap /etc/postfix/vmailbox
	sudo cp dovecot/dovecot.conf /etc/dovecot/dovecot.conf
	sudo cp dovecot/passwd /etc/dovecot/passwd

start:
	sudo postfix start
	sudo systemctl start dovecot.service

deploy:
	rsync -av ./ ravi@13.71.112.248:~/mail-setup
	ssh ravi@13.71.112.248 "cd mail-setup && make setup && tail -f /var/log/mail.log"

.PHONY: setup install users dir stop configuration start
