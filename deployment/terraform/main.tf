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
resource "heroku_app" "agent-backend" {
  name = "${var.stage}-agent-backend"
  stack = "container"
  region = "eu"

  config_vars = {
    TOKEN_SECRET = var.token_secret
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
