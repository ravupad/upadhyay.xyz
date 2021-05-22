# setup: install
# setup: create-users
setup: create-directories
setup: stop-services
setup: configuration
setup: start

install:
	apt-get install postfix
	apt-get install dovecot-core dovecot-imapd

create-users:
	groupadd -g 2000 virtualmail
	useradd -g virtualmail -u 2000 virtualmail -d /home/virtualmailboxes -m
	usermod -a -G virtualmail postfix

create-directories:
	mkdir -p /home/virtualmailboxes/upadhyay.xyz
	chown -R virtualmail:virtualmail /home/virtualmailboxes
	chmod 770 /home/virtualmailboxes

stop-services:
	postfix stop
	systemctl stop dovecot.service

configuration:
	./build.sh upadhyay.xyz /home/virtualmailboxes Maildir 2000 2000

start:
	postfix start
	systemctl start dovecot.service

push:
	rsync -av ./ ravi@upadhyay.xyz:~/mail-setup --delete
	ssh ravi@upadhyay.xyz "cd mail-setup && sudo make setup && tail -f /var/log/mail.log"

.PHONY: setup install create-users create-directories stop-services configuration start push
