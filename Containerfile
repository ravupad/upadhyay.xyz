FROM ubuntu:latest
RUN apt update && \
    apt install -y postfix && \
	apt install -y dovecot-core dovecot-imapd && \
	apt install -y opendkim opendkim-tools && \
	apt install -y postfix-policyd-spf-python && \
    apt install -y build-essential
WORKDIR /src
COPY . .
RUN make setup
ENTRYPOINT make start
