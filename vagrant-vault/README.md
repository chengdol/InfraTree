# Vagrant Vault

## Procedure
Git clone repo to your local host.

Spin up Vault server and client:
```bash
vagrant up
```

Currently you need to manually launch the vaule server in dev mode:
```bash
vault server -dev-listen-address 0.0.0.0:8200 -dev
```
Using `http://localhost:8200` to access Vault UI.

```bash
## Vault API access
export VAULT_ADDR='http://0.0.0.0:8200'
export VAULT_TOKEN=<Root Token>

## login to vault server need VAULT_TOKEN to login
vault login
```

