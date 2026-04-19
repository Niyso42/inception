#sert a construire l'image (installer mdb, copier les fichiers, donner les droits, definir le demarrage)

FROM debian:bullseye

RUN apt-get update && apt-get install -y mariadb-server && rm -rf /var/lib/apt/lists/*

RUN rm -rf /var/lib/mysql/*

RUN mkdir -p /run/mysqld /var/lib/mysql && chown -R mysql:mysql /run/mysqld /var/lib/mysql

COPY ./init.sh /usr/local/bin/init.sh

RUN chmod +x /usr/local/bin/init.sh

CMD ["/usr/local/bin/init.sh"]

