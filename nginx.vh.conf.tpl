server {
	listen       ${SITE_PORT};
	server_name  ${SITE_HOST};

	#charset koi8-r;
	access_log  /var/log/nginx/log/host.access.log  main;

	root ${SITE_ROOT};

	location / {
		index index.php;
	}

	#error_page  404              /404.html;

	# redirect server error pages to the static page /50x.html
	#
	#error_page   500 502 503 504  /50x.html;
	#location = /50x.html {
	#	root   /usr/share/nginx/html;
	#}

	# proxy the PHP scripts to Apache listening on 127.0.0.1:80
	#
	#location ~ \.php$ {
	#    proxy_pass   http://127.0.0.1;
	#}

	# pass the PHP scripts to FastCGI server listening on 127.0.0.1:9000

	location ~ \.php$ {
	    fastcgi_pass   ${FASTCGI_PATH};
	    fastcgi_index  index.php;
	    fastcgi_param  SCRIPT_FILENAME  $document_root$fastcgi_script_name;
	    include        /etc/nginx/fastcgi_params;
	}

	# deny access to .htaccess files, if Apache's document root
	# concurs with nginx's one
	#
	#location ~ /\.ht {
	#    deny  all;
	#}
}