#!/bin/bash

usage() {
  echo "Not all environment variables are set."
}

RELEASE_NAME=emmyjane-net

if [[ $1 == "-y" ]]; then
  CMD="helm upgrade --install"

  if [[ "${WORDPRESS_USER}" == "" ]] \
    || [[ "${WORDPRESS_PASS}" == "" ]] \
    || [[ "${WORDPRESS_HOST}" == "" ]] \
    || [[ "${WORDPRESS_EMAIL}" == "" ]] \
    || [[ "${WORDPRESS_DB_USER}" == "" ]] \
    || [[ "${WORDPRESS_DB_ROOT_PASS}" == "" ]] \
    || [[ "${WORDPRESS_DB_PASS}" == "" ]] \
    || [[ "${RELEASE_NAME}" == "" ]]
  then
    usage
    exit 1
  fi
else
  CMD="helm template"
fi

${CMD} \
  --set "wordpress.wordpressUsername=${WORDPRESS_USER}" \
  --set "wordpress.wordpressPassword=${WORDPRESS_PASS}" \
  --set "wordpress.wordpressEmail=${WORDPRESS_EMAIL}" \
  --set "wordpress.mariadb.auth.username=${WORDPRESS_DB_USER}" \
  --set "wordpress.mariadb.auth.rootPassword=${WORDPRESS_DB_ROOT_PASS}" \
  --set "wordpress.mariadb.auth.password=${WORDPRESS_DB_PASS}" \
  --set "wordpress.ingress.hostname=${WORDPRESS_HOST}" \
  --set "wordpress.ingress.extraTls[0].hosts[0]=${WORDPRESS_HOST}" \
  --set "wordpress.ingress.extraTls[0].secretName=${WORDPRESS_HOST}" \
  --values ./values.yaml \
  ${RELEASE_NAME} \
  .
