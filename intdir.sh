#!/bin/bash
                                                                              # Set the path to your Apache configuration file                              apache_config_file="/data/data/com.termux/files/usr/etc/apache2/httpd.conf"
# Add the entire VirtualHost block to the configuration file                  cat <<EOL >> "$apache_config_file"
<VirtualHost *:8080>
    ServerAdmin webmaster@localhost                                               DocumentRoot /data/data/com.termux/files/usr/share/apache2/default-site/htdocs/

    <Directory /data/data/com.termux/files/usr/share/apache2/default-site/htdocs/>                                                                                  Options Indexes FollowSymLinks
        AllowOverride All
        Require all granted
    </Directory>


    <Directory /data/data/com.termux/files/usr/share/apache2/default-site/htdocs/intranet-tmpl/>
        Options Indexes FollowSymLinks
        AllowOverride All
        Require all granted
    </Directory>

    RewriteEngine On
    RewriteCond %{REQUEST_URI} !^/intranet-tmpl [NC]
    RewriteCond %{REQUEST_URI} !^/index\.php$ [NC]
    RewriteCond %{REQUEST_FILENAME} !-f
    RewriteCond %{REQUEST_FILENAME} !-d
    RewriteRule ^(.*)$ /index.html [L,QSA]
</VirtualHost>
EOL

# Restart Apache
 service apache2 restart

echo "Configuration updated. Apache restarted."
