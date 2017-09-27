FROM ubuntu:16.04

ARG BUILD_STACK=true
ARG BUILD_APPLICATION=true

# Dependency - Ansible {
RUN apt-get update \
 && apt-get install -y software-properties-common \
 && apt-add-repository ppa:ansible/ansible \
 && apt-get update \
 && apt-get install -y ansible
# }

# Dependency - Extra Packages {
RUN apt-get update \
 && apt-get install -y git
# }

# Build - Stack {
COPY root /
RUN cd /ansible \
 && ansible-galaxy install -r requirements.yml -p ./roles \
 && build-stack
# }

# Build - Application {
COPY application /application
RUN build-application
# }

# Run !
CMD run
