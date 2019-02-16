FROM jenkins/jenkins:2.163
MAINTAINER Boonkuae Boonsutta <boonkuae.boo@ascendcorp.com>

# Suppress apt installation warnings
ENV DEBIAN_FRONTEND=noninteractive


# Change to root user
USER root

RUN cat /etc/os-release

# Used to control Docker and Docker Compose versions installed
# NOTE: As of February 2016, AWS Linux ECS only supports Docker 1.9.1
ARG DOCKER_ENGINE=18.06.2
ARG DOCKER_COMPOSE=1.23.2


# Install base packages
RUN apt-get update -y && apt-get install apt-transport-https \
         ca-certificates \
         curl \
         gnupg2 \
         software-properties-common -y
# Install Docker Engine
RUN curl -fsSL https://download.docker.com/linux/$(. /etc/os-release; echo "$ID")/gpg | apt-key add -

RUN  apt-key fingerprint 0EBFCD88

RUN add-apt-repository \
       "deb [arch=amd64] https://download.docker.com/linux/$(. /etc/os-release; echo "$ID") \
       $(lsb_release -cs) \
       stable"

RUN apt-get update -y
RUN apt-cache madison docker-ce
RUN apt-get install docker-ce=${DOCKER_ENGINE:-18.06.2}~ce~3-0~debian -y
RUN docker -v

RUN usermod -aG docker jenkins && \
    usermod -aG users jenkins

# Install Docker Compose
RUN apt-get install python-dev python-setuptools gcc make libssl-dev -y
RUN easy_install pip
RUN pip install docker-compose==${DOCKER_COMPOSE:-1.23.2}
RUN pip install ansible boto boto3

RUN docker-compose -v

# Change to jenkins user
USER jenkins


COPY executors.groovy /home/test/jenkins_home/executors.groovy
# Add Jenkins plugins

COPY plugins.txt /usr/share/jenkins/plugins.txt
RUN /usr/local/bin/install-plugins.sh < /usr/share/jenkins/plugins.txt
