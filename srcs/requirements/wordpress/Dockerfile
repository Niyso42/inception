FROM debian:bullseye

RUN mkdir -p /run/php

RUN apt-get update && apt-get install -y \
	php7.4 \
	php7.4-fpm \
	php7.4-mysql \
	wget \
	mariadb-client \
&& rm -rf /var/lib/apt/lists/*

RUN wget https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar \
	-O /usr/local/bin/wp \
	&& chmod +x /usr/local/bin/wp

RUN sed -i 's|^listen = .*|listen = 9000|' /etc/php/7.4/fpm/pool.d/www.conf

WORKDIR /var/www/html

COPY ./init.sh /usr/local/bin/init.sh

RUN chmod +x /usr/local/bin/init.sh

CMD ["/usr/local/bin/init.sh"]
