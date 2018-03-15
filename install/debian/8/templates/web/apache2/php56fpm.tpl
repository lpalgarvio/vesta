<VirtualHost %ip%:%web_port%>

    ServerName %domain_idn%
    %alias_string%
    ServerAdmin %email%
    DocumentRoot %docroot%
    ScriptAlias /cgi-bin/ %home%/%user%/web/%domain%/cgi-bin/
    Alias /vstats/ %home%/%user%/web/%domain%/stats/
    Alias /error/ %home%/%user%/web/%domain%/document_errors/
    SuexecUserGroup %user% %group%
    CustomLog /var/log/%web_system%/domains/%domain%.bytes bytes
    CustomLog /var/log/%web_system%/domains/%domain%.log combined
    ErrorLog /var/log/%web_system%/domains/%domain%.error.log
    <Directory %docroot%>
        AllowOverride All
        Options +Includes -Indexes +ExecCGI
        <IfModule proxy_fcgi_module>
            # Enable http authorization headers
            <IfModule setenvif_module>
                SetEnvIfNoCase ^Authorization$ "(.+)" HTTP_AUTHORIZATION=$1
            </IfModule>
            <FilesMatch ".+\.ph(p[3457]?|t|tml)$">
                SetHandler "proxy:unix:/run/php/php5.6-fpm.sock|fcgi://localhost"
            </FilesMatch>
            <FilesMatch ".+\.phps$">
                # Deny access to raw php sources by default
                # To re-enable it's recommended to enable access to the files
                # only in specific virtual host or directory
                Require all denied
            </FilesMatch>
            # Deny access to files without filename (e.g. '.php')
            <FilesMatch "^\.ph(p[3457]?|t|tml|ps)$">
                Require all denied
            </FilesMatch>
        </IfModule>
    </Directory>
    <Directory %home%/%user%/web/%domain%/stats>
        AllowOverride All
    </Directory>
    IncludeOptional %home%/%user%/conf/web/%web_system%.%domain%.conf*

    Redirect permanent / https://%domain_idn%/

</VirtualHost>

