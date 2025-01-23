####using loacl method  secrets for team1#####
  locals {
    secrets = {
      "aws-master-account" = {
        username = "master-admin"
        password = "master-password"
        region   = "singapore"
      }
      "aws-dev-account" = {
        username = "dev-admin"
        password = "dev-password"
        region   = "japan"
      }
      "aws-shopping-account" = {
        username = "shopping-admin"
        password = "shopping-password"
        region   = "thailand"
      }
    }
  }