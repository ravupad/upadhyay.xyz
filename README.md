## To setup PO

## To setup SPF and OPENDKIM
https://web.archive.org/web/20210730093358/https://www.linuxbabe.com/mail-server/setting-up-dkim-and-spf

### SPF 
SPF policy checks if the IP from which email is received can send mail for the email domain.
The authorization is fetched from the domains DNS TXT record.

### OPENDKIM
OpenDKIM signs the email header using a private key. The public key is stored in DNS TXT record.

## Certificates 
A folder needs to be mounted to the container as /certs. The folder should contain files fullchain.pem and privkey.pem.

### With Certbot Cloudflare plugin
snap install certbot --classic
snap set certbot trust-plugin-with-root=ok
snap install certbot-dns-cloudflare
certbot certonly --dns-cloudflare --dns-cloudflare-credentials cloudflare-creds.ini -d $(domain)

This will fetch the certificates and place them in /etc/letsencrypt/live/$(domain)
The files in this folder consists of symlinks. To create a folder with the actual contents run
cp -L /etc/letsencrypt/live/upadhyay.xyz/* certs/

