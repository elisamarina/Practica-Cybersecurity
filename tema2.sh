#!/bin/bash

# PARTEA 1

echo "--- Acum se genereaza primul certificat... ---"
openssl req -x509 -newkey rsa:2048 -nodes \
  -keyout certificat_tema.key \
  -out certificat_tema.crt \
  -sha256 \
  -days 365 \
  -subj "/C=RO/ST=Bucuresti/O=Tema/CN=siteulmeu.com"
echo " Fisierul'certificat_tema.crt' a fost creat."
echo ""

echo "--- Acum se genereaza al doilea certificat... ---"

openssl genrsa -out cheia_mea_separata.key 2048

openssl req -x509 -new -nodes \
  -key cheia_mea_separata.key \
  -out certificat_din_cheie.crt \
  -sha256 \
  -days 365 \
  -subj "/C=RO/ST=Bucuresti/O=Tema/CN=alt_site.com"


echo "--- Acum vedem ce certificat are google.com... ---"
echo | openssl s_client -connect google.com:443
echo ""

# PARTEA 2

echo "--- Se genereaza certificatul pentru server... ---"
openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
  -keyout /etc/ssl/private/apache.key \
  -out /etc/ssl/certs/apache.crt \
  -subj "/C=RO/CN=localhost"
echo "Gata, certificatul pentru server e pus unde trebuie."

echo "--- Se configureaza serverul... ---"

a2enmod ssl > /dev/null

# !Aceste doua comenzi modifica ele singure fisierul de configurare.
sed -i 's|SSLCertificateFile.*|SSLCertificateFile /etc/ssl/certs/apache.crt|' /etc/apache2/sites-available/default-ssl.conf
sed -i 's|SSLCertificateKeyFile.*|SSLCertificateKeyFile /etc/ssl/private/apache.key|' /etc/apache2/sites-available/default-ssl.conf

# Activam site-ul cu SSL.
a2ensite default-ssl.conf > /dev/null

# Restart pentru a vedea schimbarile
systemctl restart apache2
echo "Serverul a fost configurat si repornit."
echo ""


# Verificare: 
# 1. Deschide Chrome sau Firefox.
# 2. Scrie sus la adresa: https://localhost
# 3. O sa apara o eroare de securitate. E normal. Apasa pe 'Advanced' si apoi 'Proceed' (sau 'Accept Risk').
# 4. Daca iti apare o pagina pe care scrie 'It works!', inseamna ca script-ul a functionat.
