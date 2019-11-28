# A WordPress Docker Image

## For development environments only

With WP-CLI, correct user permissions, XDebug, MailHog connection and HTTPS.

To use MailHog you need to add this to php.ini

`sendmail_path='/usr/bin/mhsendmail --smtp-addr="mailhog:1025"'`

It is possible mapping a volume to an additional .ini file. Example:

`- ./dev.ini:/usr/local/etc/php/conf.d/dev.ini`

This dev.ini file will be loaded with the additional PHP settings.
