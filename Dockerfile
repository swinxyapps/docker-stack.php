FROM ubuntu:16.04

# Install Ansible

RUN apt-get update \
 && apt-get install -y software-properties-common \
 && apt-add-repository ppa:ansible/ansible \
 && apt-get update \
 && apt-get install -y ansible

# Install Extra Dependencies

RUN apt-get update && apt-get install -y git

# Apply Filesystem

RUN mkdir -p /var/www/application

COPY root /
COPY public /var/www/application/public

# Provision

RUN cd /ansible \
 && ansible-galaxy install -r requirements.yml -p ./roles \
 && ansible-playbook site.yml

# Container Start

CMD entrypoint.sh