# Ansible Role: Nginx

[![Build Status](https://travis-ci.org/tschifftner/ansible-role-nginx.svg)](https://travis-ci.org/tschifftner/ansible-role-nginx)

Installs nginx on Debian/Ubuntu linux servers.

## Requirements

ansible 1.7+

## Role Variables

Available variables are listed below, along with default values (see `defaults/main.yml`):

```
nginx_package: nginx-full
nginx_package_state: 'latest'
```

### nginx.conf adjustments

Variables in nginx.conf can be set by
```
nginx_owner: www-data
nginx_group: www-data
nginx_worker_processes: '{{ ansible_processor_cores * ansible_processor_count }}'
nginx_worker_connections: '{{ 768 if ansible_processor_count == 1 else 2048 }}'
nginx_pid_file: '/run/nginx.pid'
nginx_multi_accept: 'on'
```

Furhter configration settings can be defined by

```
nginx_extra_http_options: |
    server_names_hash_bucket_size 64;
    server_name_in_redirect off;    
```

### Secure nginx

Default vhost can be kept or removed by
```
nginx_remove_default_vhost: true
```

### Define vHosts

```
nginx_vhosts:
  example.com:
    - server_name: www.example.com
      listen: 80
      root: '/var/www/example.com/html'
      access_log: '/var/www/example.com/logs/nginx-access.log'
      error_log: '/var/www/example.com/logs/nginx-error.log'
      extra_parameters: |
        include {{ nginx_additional_templates.0.dest }};

    - server_name: example.com
      listen: 80
      return: '301 http://www.example.com$request_uri;'

  secure-example.com:
    - server_name: www.secure-example.com
      listen: '444 spdy'
      ssl_certificate: '/etc/nginx/ssl/secure-example.com/certificate.crt'
      ssl_certificate_key: '/etc/nginx/ssl/secure-example.com/certificate.key'
      access_log: '/var/www/secure-example.com/logs/nginx-access.log'
      error_log: '/var/www/secure-example.com/logs/nginx-error.log'
      root: '/var/www/secure-example.com/html/'
      extra_parameters: |
        include {{ nginx_additional_templates.1.dest }};

    - server_name: secure-example.com
      listen: 80
      return: '301 http://www.example.com$request_uri;'

```

### Use additional nginx templates

Additional templates can be uploaded and included in your vhost:

```
nginx_additional_templates:
  - src: 'nginx/magento.conf'
    dest: '/etc/nginx/snippets/example.magento.conf'
    php_socket_file: '/run/php5-fpm-magento.socket'
    
  - src: 'nginx/magento.conf'
    dest: '/etc/nginx/snippets/secure-example.magento.conf'
    php_socket_file: '/run/php5-fpm-magento.socket'
```

### Upload ssl certifications

```
nginx_ssl_certificates:
  - save_path: '/etc/nginx/ssl/secure-example.com/'
    certificate_key: "{{ lookup('file', 'local/path/certificate.key') }}"
    certificate: "{{ lookup('file', 'local/path/certificate.crt') }}"
    intermediate_certificate: "{{ lookup('file', 'local/path/intermediate.crt') }}"
    root_certificate: "{{ lookup('file', 'local/path/root.crt') }}"
```

save_path, certificate_key and certificate are required!
intermediate_certificate and root_certificate is not required but highly recommended!

### Define configuration files in /etc/nginx/conf.d/

```
nginx_config_files:
  - ssl.conf
  - secure.conf
```

### Install GeoIp

To install geoip the variable ```install_geoip``` needs to be set.
```
# GeoIP
install_geoip: true
geoip_download_url: "http://geolite.maxmind.com/download/geoip/database/GeoLiteCountry/GeoIP.dat.gz"
```

### Upstreams

Upstreams can easily be defined:

```
nginx_upstreams:
  - name: 'varnish'
    servers:
      - 'localhost:6081'
      - 'localhost:8080 backup'
```

### Generate dhparam

Dhparam key file is always generated but the filepath can be adjusted:

```
nginx_dhparam_file: '/etc/nginx/ssl/dhparam.pem'
```

## Dependencies

None.

## Example Playbook

    - hosts: server
      roles:
        - { role: tschifftner.nginx }

## Supported OS

Ansible          | Debian Jessie    | Ubuntu 14.04    | Ubuntu 12.04
:--------------: | :--------------: | :-------------: | :-------------: 
1.7              | Yes              | Yes             | Yes
1.8              | Yes              | Yes             | Yes
1.9              | Yes              | Yes             | Yes
2.0.1*           | Yes              | Yes             | Yes

*) 2.0.0.0, 2.0.0.1, 2.0.0.2 are not supported!


## License

MIT / BSD

## Author Information

 - Tobias Schifftner, @tschifftner