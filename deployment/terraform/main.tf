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

variable "token_secret" {
  description = "Secret needed for JWT"
}

## backend
resource "heroku_app" "agent_backend" {
  name = "${var.stage}-agent_backend"
  stack = "container"
  region = "eu"

  config_vars = {
    TOKEN_SECRET = var.token_secret
  }
}

resource "heroku_addon" "postgres" {
  app = heroku_app.agent_backend.id
  plan = "heroku-postgresql:hobby-dev"
}

resource "heroku_build" "agent_backend-build" {
  app = heroku_app.agent_backend.id
  source {
    path = "backend"
  }
