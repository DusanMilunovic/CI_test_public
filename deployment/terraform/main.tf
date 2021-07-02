terraform {
  required_providers {
    heroku = {
      source  = "heroku/heroku"
      version = "~> 4.0"
    }
  }
  backend "pg" {
  }
}

provider "heroku" {}

variable "stage" {
  description = "Stage of the app (staging or production)"
}

variable "flask_secret_key" {
  description = "Secret needed for flask"
}

variable "command" {
  description = "Command for entrypoint.sh"
}

variable "flask_app" {
  description = "Flask variable"
}

variable "flask_env" {
  description = "Flask variable"
}

variable "sql_host" {
  description = "Sql host"
}

variable "sql_password" {
  description = "Sql password"
}

variable "sql_port" {
  description = "Sql port"
}

variable "sql_db_name" {
  description = "Database name"
}

variable "sql_username" {
  description = "Sql username"
}

variable "database" {
  description = "Sql database provider"
}

variable "postgres_password" {
  description = "Postgres password"
}

variable "postgres_user" {
  description = "Postgres username"
}

variable "postgres_db" {
  description = "Name of postgres database"
}


## backend
resource "heroku_app" "agent-backend" {
  name = "${var.stage}-agent-backend"
  stack = "container"
  region = "eu"

  config_vars = {
    FLASK_SECRET_KEY = var.flask_secret_key
    COMMAND = var.command
    FLASK_APP = var.flask_app
    FLASK_ENV = var.flask_env
    SQL_HOST = var.sql_host
    SQL_PASSWORD = var.sql_password
    SQL_PORT = var.sql_port
    SQL_DB_NAME = var.sql_db_name
    SQL_USERNAME = var.sql_username
    DATABASE = var.database
    POSTGRES_PASSWORD = var.postgres_password
    POSTGRES_USER = var.postgres_user
    POSTGRES_DB = var.postgres_db
  }
}

resource "heroku_addon" "postgres" {
  app = heroku_app.agent-backend.id
  plan = "heroku-postgresql:hobby-dev"
}

resource "heroku_build" "agent-backend-build" {
  app = heroku_app.agent-backend.id
  source {
    path = "agent-backend"
  }
}
