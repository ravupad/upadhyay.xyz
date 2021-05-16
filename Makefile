setup: install
setup: stop
setup: configuration
setup: start

install:
	sudo apt-get install postfix
	sudo apt-get install dovecot-core dovecot-imapd

stop:
	sudo systemctl stop postfix.service
	sudo systemctl stop dovecot.service

configuration:
	

start:
	sudo systemctl start postfix.service
	sudo systemctl start dovecot.service

.PHONY: setup install