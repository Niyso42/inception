#!/bin/bash
set -e

echo "WordPress: Waiting MariaDB..."
while ! mysqladmin --user=$SQL_USER  --password=$SQL_PASSWORD -P 4306 --host=mariadb ping --silent; do
    sleep 2
done

mkdir -p /run/php
mkdir -p /var/www/html

cd /var/www/html

if [ ! -f "/var/www/html/wp-load.php" ]; then
	echo "Downloading WordPress..."
	wp core download --allow-root
fi

if [ ! -f "/var/www/html/wp-config.php" ]; then
	echo "Creating wp-config.php..."
	wp config create \
		--allow-root \
		--dbname="${SQL_DATABASE}" \
		--dbuser="${SQL_USER}" \
		--dbpass="${SQL_PASSWORD}" \
		--dbhost="${SQL_HOST}:4306"
fi

if ! wp core is-installed --allow-root; then
	echo "Installing WordPress..."
	wp core install \
		--allow-root \
		--url="https://${DOMAIN_NAME}" \
		--title="${WP_TITLE}" \
		--admin_user="${WP_ADMIN_USER}" \
		--admin_password="${WP_ADMIN_PASSWORD}" \
		--admin_email="${WP_ADMIN_EMAIL}"

	echo "Creating additional user..."
	wp user create "${WP_USER}" "${WP_USER_EMAIL}" \
		--allow-root \
		--user_pass="${WP_USER_PASSWORD}"
fi

echo "Starting PHP-FPM..."
exec /usr/sbin/php-fpm7.4 -F