#!/bin/bash

ensureDockerIsInstalled() {
  if [ "$(/bin/bash -c 'which docker')" == "" ] ; then
    # Install Docker (latest stable)
    curl -sSL https://get.docker.com/ | sh
  fi
}

configureArtifactory() {
  mkdir -p /vagrant/shared/{data,logs,etc}
  chmod ugoa+rw -R /vagrant/shared
}

runArtifactory() {
  # docker pull docker.bintray.io/jfrog/artifactory-oss:latest
  # docker run -d --name artifactory \
  #   -p 8081:8081 \
  #   -v /vagrant/shared/data:/var/opt/jfrog/artifactory/data \
  #   -v /vagrant/shared/logs:/var/opt/jfrog/artifactory/logs \
  #   -v /vagrant/shared/etc:/var/opt/jfrog/artifactory/etc \
  #   docker.bintray.io/jfrog/artifactory-oss:latest

  docker stop artifactory 2>/dev/null || echo ""
  docker rm artifactory 2>/dev/null || echo ""
  docker run -d \
    --name artifactory \
    -p 8081:8080 \
    -v /vagrant/shared/data:/artifactory/data \
    -v /vagrant/shared/logs:/artifactory/logs \
    -v /vagrant/shared/backup:/artifactory/backup \
    mattgruter/artifactory
}

main() {
  ensureDockerIsInstalled;
  configureArtifactory;
  runArtifactory;
}

main;
