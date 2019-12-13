FROM wordpress:php7.3-apache

# Install the PHP extensions we need
RUN set -ex; \
	\
	apt-get update; \
	apt-get install -y \
		git \
		libzip-dev \
		mariadb-client \
		sudo \
		subversion \
	; \
	apt-get install -y \
		--no-install-recommends ssl-cert \
	; \
	rm -rf /var/lib/apt/lists/*; \
	a2enmod ssl; \
	a2ensite default-ssl; \
	docker-php-ext-install zip; \
	yes | pecl install xdebug

# Install wp-cli, and allow it to regenerate .htaccess files
# Use /usr/local/bin/wp-cli.phar to run it as root
# and wp to run it as www-data (your own user)
COPY wp-su.sh /usr/local/bin/wp
RUN	curl -o /usr/local/bin/wp-cli.phar https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar; \
	chmod a+x /usr/local/bin/wp-cli.phar; \
	{ \
		echo 'apache_modules:'; \
		echo '  - mod_rewrite'; \
	} > /var/www/wp-cli.yml

# Install MailHog's mhsendmail
RUN curl -Lo /usr/bin/mhsendmail https://github.com/mailhog/mhsendmail/releases/download/v0.2.0/mhsendmail_linux_amd64; \
	chmod a+x /usr/bin/mhsendmail;

WORKDIR /var/www/html
VOLUME /var/www/html

# Change www-data user to match the host system UID and GID and chown www directory
RUN usermod --non-unique --uid 1000 www-data \
  && groupmod --non-unique --gid 1000 www-data \
  && chown -R www-data:www-data /var/www

EXPOSE 80 443
# Overrides wp docker default entrypoint
COPY docker-entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]

CMD ["apache2-foreground"]
