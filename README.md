# Ansible Role: Nginx

[![Build Status](https://travis-ci.org/tschifftner/ansible-role-common.svg)](https://travis-ci.org/tschifftner/ansible-role-common)

Installs nginx on Debian/Ubuntu linux servers.

## Requirements

None.

## Role Variables

Available variables are listed below, along with default values (see `defaults/main.yml`):

    nginx_package: nginx-full

## Dependencies

None.

## Example Playbook

    - hosts: server
      roles:
        - { role: tschifftner.ansible-role-nginx }

## License

MIT / BSD

## Author Information

 - Tobias Schifftner, @tschifftner