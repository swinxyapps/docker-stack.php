FROM ubuntu:16.04

ARG BUILD_STACK=true
ARG BUILD_APPLICATION=false

# Install Ansible
RUN apt-get update \
 && apt-get install -y software-properties-common \
 && apt-add-repository ppa:ansible/ansible \
 && apt-get update \
 && apt-get install -y ansible

# Install Extra Dependencies
RUN apt-get update && apt-get install -y git

# Apply Filesystem
COPY root        /
COPY application /application

# Provision
RUN cd /ansible && ansible-galaxy install -r requirements.yml -p ./roles
RUN build-stack
RUN build-application

# Container Start
CMD run
