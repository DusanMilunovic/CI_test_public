#!/bin/bash

echo "START"
VERSION=${1}
HEROKU_EMAIL=${2}
HEROKU_API_KEY=${3}
TERRAFORM_PG_BACKEND=${4}
TOKEN_SECRET=${5}

STAGE=${6-stage}
DOCKERHUB_USERNAME=${7:-dusanpanda}
CONTAINER_NAME=${8:-terraform-deploy}

echo "${HEROKU_EMAIL}"
echo "${HEROKU_API_KEY}"


BACKEND_IMAGE=${DOCKERHUB_USERNAME}/agent_backend:${VERSION}

docker create \
  --workdir /deployment \
  --entrypoint sh \
  --env HEROKU_API_KEY="${HEROKU_API_KEY}" \
  --env HEROKU_EMAIL="${HEROKU_EMAIL}" \
  --env TERRAFORM_PG_BACKEND="${TERRAFORM_PG_BACKEND}" \
  --env STAGE="${STAGE}" \
  --env TOKEN_SECRET="${TOKEN_SECRET}" \
  --env BACKEND_IMAGE="${BACKEND_IMAGE}" \
  --env COMMAND="run_server" \
  --name "$CONTAINER_NAME" \
  danijelradakovic/heroku-terraform \
  deploy.sh

docker cp deployment/. "${CONTAINER_NAME}":/deployment/
docker start -i "${CONTAINER_NAME}"
docker rm "${CONTAINER_NAME}"