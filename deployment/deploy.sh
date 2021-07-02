#!/bin/sh

ALL_HEROKU_APPS=$(heroku apps) && export ALL_HEROKU_APPS

case $ALL_HEROKU_APPS in (*"$TERRAFORM_PG_BACKEND"*)
    echo "EXISTING BACKEND FOUND"
    ;;
(*)
   heroku create $TERRAFORM_PG_BACKEND
   heroku addons:create heroku-postgresql:hobby-dev --app $TERRAFORM_PG_BACKEND
   ;;
esac

cd terraform || exit

rm -rf ./agent-backend/Dockerfile

# echo "FROM $BACKEND_IMAGE" >> ./agent-backend/Dockerfile
echo "FROM dusanpanda/agent_backend:latest" >> ./agent-backend/Dockerfile
cat ./agent-backend/Dockerfile

DATABASE_URL=$(heroku config:get DATABASE_URL --app "$TERRAFORM_PG_BACKEND") && export DATABASE_URL
terraform init -backend-config="conn_str=$DATABASE_URL"
terraform apply -auto-approve -var stage=${STAGE} \
                              -var flask_secret_key=${FLASK_SECRET_KEY} \
                              -var command=${COMMAND} \
                              -var flask_app=${FLASK_APP} \
                              -var flask_env=${FLASK_ENV} \
                              -var sql_host=${SQL_HOST} \
                              -var sql_password=${SQL_PASSWORD} \
                              -var sql_port=${SQL_PORT} \
                              -var sql_db_name=${SQL_DB_NAME} \
                              -var sql_username=${SQL_USERNAME} \
                              -var database=${DATABASE} \
                              -var postgres_password=${POSTGRES_PASSWORD} \
                              -var postgres_user=${POSTGRES_USER} \
                              -var postgres_db=${POSTGRES_DB} \
                              