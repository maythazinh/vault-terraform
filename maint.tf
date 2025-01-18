resource "vault_auth_backend" "userpass_team1" {
  type = "userpass"
  path = "team1"
}

resource "vault_auth_backend" "userpass_team2" {
  type = "userpass"
  path = "team2"
}

# resource "vault_auth_backend" "userpass_team3" {
#   type = "userpass"
#   path = "team3"
# }

resource "vault_policy" "team1_policy" {
  name = "team1-policy"

  policy = <<EOT
path "kvv2-team1/*" {
  capabilities = ["read", "list"]
}

path "cubbyhole/*" {
  capabilities = ["deny"]
}
EOT
}

resource "vault_policy" "team2_policy" {
  name = "team2-policy"

  policy = <<EOT
path "kvv2-team2/*" {
  capabilities = ["read", "list"]
}
EOT
}

resource "vault_mount" "team1_kvv2_mount" {
  path        = "kvv2-team1"
  type        = "kv-v2"
  description = "This is an kv-v2 secrets engine mounted at the path kvv2-team1"
}

resource "vault_mount" "team2_kvv2_mount" {
  path        = "kvv2-team2"
  type        = "kv-v2"
  description = "This is an kv-v2 secrets engine mounted at the path kvv2-team2"
}

resource "vault_kv_secret_v2" "kvv2_team1_master_secret" {
  mount = vault_mount.team1_kvv2_mount.path
  name  = "aws-master-account"
  data_json = jsonencode(
    {
      username = "master-admin"
      password = "master-Passw0rd"
      region   = "singapore"
    }
  )
}

resource "vault_kv_secret_v2" "kvv2_team1_dev_secret" {
  mount = vault_mount.team1_kvv2_mount.path
  name  = "aws-dev-account"
  data_json = jsonencode(
    {
      username = "dev-admin"
      password = "dev-Passw0rd"
      region   = "japan"
    }
  )
}


resource "vault_generic_endpoint" "team1-users" {
  path = "auth/team1/users/dev-team1"

  data_json = <<EOT
{
  "password": "team1"
}
EOT
}

resource "vault_generic_endpoint" "team2-users" {
  path = "auth/team2/users/dev-team2"

  data_json = <<EOT
{
  "password": "team2"
}
EOT
}

resource "vault_identity_entity_policies" "bind-dev-team1" {
  policies = ["team1-policy"]
  entity_id = "f090ccc7-d8d7-2663-4995-75dd55c16163"
}

resource "vault_identity_entity_policies" "bind-dev-team2" {
  policies = ["team2-policy"]
  entity_id = "6168f223-4955-33dd-447d-c3e381de446c"
}
