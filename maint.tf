### Create auth methods for team1 and team2
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

### Define policies for team1 and team2
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

### Mount KV-v2 secrets engines for team1 and team2
resource "vault_mount" "team1_kvv2_mount" {
  path        = "kvv2-team1"
  type        = "kv-v2"
  description = "This is a kv-v2 secrets engine mounted at the path kvv2-team1"
}

resource "vault_mount" "team2_kvv2_mount" {
  path        = "kvv2-team2"
  type        = "kv-v2"
  description = "This is a kv-v2 secrets engine mounted at the path kvv2-team2"
}

### Create secrets for team1
resource "vault_kv_secret_v2" "kvv2_team1_master_secret" {
  mount = vault_mount.team1_kvv2_mount.path
  name  = "aws-master-account"

  data_json = jsonencode({
    username = "master-admin"
    password = "master-Passw0rd"
    region   = "singapore"
  })
}

resource "vault_kv_secret_v2" "kvv2_team1_dev_secret" {
  mount = vault_mount.team1_kvv2_mount.path
  name  = "aws-dev-account"

  data_json = jsonencode({
    username = "dev-admin"
    password = "dev-Passw0rd"
    region   = "japan"
  })
}

### Add users under team1
resource "vault_generic_endpoint" "team1-users" {
  depends_on           = [vault_auth_backend.userpass_team1]
  path                 = "auth/team1/users/dev-team1"
  ignore_absent_fields = true

  data_json = <<EOT
{
  "policies": ["team1-policy"],
  "password": "team1"
}
EOT
}

### Add users under team2
resource "vault_generic_endpoint" "team2-users" {
  depends_on           = [vault_auth_backend.userpass_team2]
  path                 = "auth/team2/users/dev-team2"
  ignore_absent_fields = true

  data_json = <<EOT
{
  "policies": ["team2-policy"],
  "password": "team2"
}
EOT
}
