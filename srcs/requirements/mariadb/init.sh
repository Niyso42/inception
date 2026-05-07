#!/bin/bash
set -e

chown -R mysql:mysql /var/lib/mysql /run/mysqld

if [ ! -d "/var/lib/mysql/${SQL_DATABASE}" ]; then
	echo "Initializing MariaDB data directory..."
	mysql_install_db --user=mysql --datadir=/var/lib/mysql

	echo "Starting MariaDB temporarily..."
	mysqld_safe --bind-address=0.0.0.0 &

	while ! mysqladmin -u root ping --silent; do
		sleep 1
	done

	echo "Creating database and users..."
mysql -u root << EOF
CREATE DATABASE IF NOT EXISTS \`${SQL_DATABASE}\`;
CREATE USER IF NOT EXISTS '${SQL_USER}'@'localhost' IDENTIFIED BY '${SQL_PASSWORD}';
CREATE USER IF NOT EXISTS '${SQL_USER}'@'%' IDENTIFIED BY '${SQL_PASSWORD}';
GRANT ALL PRIVILEGES ON \`${SQL_DATABASE}\`.* TO '${SQL_USER}'@'localhost';
GRANT ALL PRIVILEGES ON \`${SQL_DATABASE}\`.* TO '${SQL_USER}'@'%';
ALTER USER 'root'@'localhost' IDENTIFIED BY '${SQL_ROOT_PASSWORD}';
FLUSH PRIVILEGES;
EOF

	echo "Shutting down temporary MariaDB server..."
	mysqladmin -u root -p"${SQL_ROOT_PASSWORD}" shutdown
fi

echo "Starting MariaDB..."
exec mysqld_safe --bind-address=0.0.0.0 --port=4306