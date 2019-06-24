server {
	listen       ${SITE_PORT};
	error_log  /var/log/nginx/error_log warn;
	access_log  /var/log/nginx/access.log  main;

	server_name  ${SITE_HOST};

	client_max_body_size 200M;

	root ${SITE_ROOT};
	index index.php;

	location ~* /(?:uploads|files)/.*\.php$ {
	  deny all;
	}

	location ~* \.(engine|inc|info|install|make|module|profile|test|po|sh|.*sql|theme|tpl(\.php)?|xtmpl)$|^(\..*|Entries.*|Repository|Root|Tag|Template)$|\.php_ {
	  return 403;
	}

	location ~* \.(pl|cgi|py|sh|lua)\$ {
	  return 403;
	}

	location ~ /(\.|wp-config.php|wp-comments-post.php|xmlrpc.php|readme.html|license.txt) {
	  deny all;
	}


	location / {
	   try_files $uri $uri/ /index.php?$args /public/index.php?$args;
	}

	location /images/ {
	   valid_referers none blocked www.${SITE_HOST} ${SITE_HOST};

		if ($invalid_referer) {
			return   403;
		}
	}

	location ~ /\. { deny all; access_log off; log_not_found off; }
	location ~ /(shell|schema|puphpet) { deny all; access_log off; log_not_found off; }
	location ~ /\/dev { deny all; access_log off; log_not_found off; }

	location ~ \.php$ { ## Execute PHP scripts
		if (!-e $request_filename) { rewrite / /index.php last; } ## Catch 404s that try_files miss

		expires off; ## Do not cache dynamic content
		fastcgi_pass ${FASTCGI_PATH};
		fastcgi_index index.php;
		fastcgi_param HTTP_RANGE $http_range;
		fastcgi_param SERVER_NAME $http_host;

		fastcgi_param QUERY_STRING     $query_string;
		fastcgi_param PATH_INFO $fastcgi_path_info;
		fastcgi_param PATH_TRANSLATED $document_root$fastcgi_path_info;
		fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
		fastcgi_split_path_info ^(.+\.php)(/.+)$;
		fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
		fastcgi_read_timeout ${FASTCGI_READ_TIMEOUT};
		include fastcgi_params; ## See /etc/nginx/fastcgi_params
	}
}