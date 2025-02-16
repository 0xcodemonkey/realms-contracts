# Realms CLI

This is in heavy development and things might not work as expected... Bring a torch to slay some STARK dragons...

This feature has been tested in
```
python 3.7.13
---
cairo-lang==0.8.1
cairo-nile==0.6.1
```

---
## Regular Setup


<details><summary>Python Setup</summary>


1. Upgrade pip: `/usr/local/bin/python -m pip install --upgrade pip` (Note: This will [break for OSX users who install via homebrew](https://github.com/Homebrew/legacy-homebrew/issues/26900). The workaround is to upgrade with homebrew: `brew install python3` or python3<area>@3.7)
2. Remove *all* previous cairo nile packages: `$ pip uninstall cairo-nile` and check with `$ pip freeze` to make sure it's removed.
3. Install nile 0.6.1: `pip install cairo-nile`
4. Install the realms_cli: `$ pip install realms_cli/` (ensure you are in the realms-contracts dir)

You now should have the realms_cli commands available when you run `$ nile`.

</details>

<details><summary>Environment Setup</summary>

1. Compile all the contracts with `$ nile compile` (The CLI calls these .json files, they are gitignored to avoid conflits.)
2. Compile the account contract `$ nile compile openzeppelin/account/Account.cairo --account_contract`

Create an `.env.nile` in the realms_cli/ directory with the following entries:

```
export STARKNET_PRIVATE_KEY=<A PRIVATE KEY>  # admin private key - see below to generate
export STARKNET_NETWORK=alpha-goerli  # different from nile_network
```
⚠️ Never commit this file!


After your initial setup you will have to rerun the following commands on each new session:

```bash
$ source realms_cli/.env.nile
```
</details>

<details><summary>Create Wallet via CLI [First time setup]</summary>

### NOTE: This is the temporary solution until native ArgentX integration

1. First create a new private key
```bash
$ nile create_pk
```
2. Save in printed private key in the .env.nile you created in the previous step as STARKNET_PRIVATE_KEY
3. The run the following to save it in your enviroment:
```
$ source realms_cli/.env.nile
```
4. The setup and deploy your account with the following:
```
$ nile setup STARKNET_PRIVATE_KEY --network goerli
```
5. Now your address will be saved in the goerli.accounts.json with the account name account-1 (NOTE: If you plan to contribute to the code, please delete reference of your account before commiting. There is a current limitation with nile that does not allow the saving of this information elsewhere.)

</details>

---

## Actions

<details><summary>Player Game Actions</summary>

This is not the full list of actions and new commands are being frequently added. To find all the current available commands run

``` bash
nile
```
---

### Mint Realm

``` bash
nile mint_realm 1

```

If your tx fails, someone has already minted this realm

---

### Set Metadata (use as temporary until production)

```
$ nile set_realm_data 1
```

---

### Approve your Realms for game usage

```
$ nile approve_realm
```

---

### Settle realm

```
$ nile settle_realm 1
```

---

### Check Lords

```
$ nile check_lords
```

---

### Check Realms

```
$ nile check_realms
```

---

### Check Resources

```
$ nile check_resources
```

Of another user:

```
$ nile check_resources --address 0x000000
```

---

### Claim resources

Claims specific realms resources

```
$ nile claim_resources 1
```

---


</details>


<details><summary>Admin Actions</summary>


The following scripts deploy all contracts necessary to test and play realms on localhost/goerli (ADMIN ONLY).

### 1. Admin

`$ nile run --network localhost realms_cli/1_deploy_admin.py`

### 2. Deploy tokens

`$ nile run --network localhost realms_cli/2_deploy_token_contracts.py`

### 3. Deploy game contracts

`$ nile run --network localhost realms_cli/3_deploy_game_contracts.py`

### 4. Init the game

`$ nile run --network localhost realms_cli/4_init_game.py`

### 5. Set Costs

`$ nile run --network localhost realms_cli/5_set_costs.py`

### 6. Troops (or any other new module that needs adding updating)

`$ nile run --network localhost realms_cli/6_deploy_troops.py`

`$ nile run --network localhost realms_cli/7_upgrade.py`

`$ nile run --network goerli realms_cli/8_deploy_AMM.py`

### Tips

If you want to check a tx hash, run either

`$ nile debug --network NETWORK TXHASH`

Or `$ starknet get_transaction_receipt --hash TXHASH` (only for non-localhost)

### Adding a plugin

Add your logic to `realms_cli/realms_cli/main.py`
Add you cli entro to `realms_cli/pyproject.toml`
Reinstall the plugin cli `pip install realms_cli/`

</details>

---
# Notes on proxy deployments 

<details><summary>Must read first</summary>

Proxy contracts have some quirks which you must understand before playing with them.

1. Proxies do not know what functions they have in them. This means you need to use the implementation abi when calling them.
2. This means when you have deployed them you must replace the .json of the proxy with the implementation .json - Seen below

```
0x0708ccaad83939596224933ffc265cf468aeaccabac7bbe6d04fee416308785d:artifacts/abis/Exchange_ERC20_1155.json:Exchange_ERC20_1155
0x01dc57f37705770448008e8083da883a06d81b28f01c6a398a010fff12703401:artifacts/abis/Exchange_ERC20_1155.json:proxy_Exchange_ERC20_1155
```

</details>

---
# Common ERrors

<strong><pre>{"code": "StarknetErrorCode.UNINITIALIZED_CONTRACT", "message": "Contract with address 0x6352aa8d59cb656526162e3fd5017bcc02a8f6f1036748cb7221a8f30e89770 is not deployed."}.</pre></strong>

First - wait 30 seconds and try again as the deployment doesn't happen immediately. 

If you're still getting this error, it likely means that your goerli.deployments.txt doesn't have account-1 (user account) or is appending the account to account-2. 

Restore your goerli.deployments.txt to its original state (use `main` branch as source of truth). Next, delete the line with account-1 (and account-2 if it exists) and re-run `nile setup STARKNET_PRIVATE_KEY --network goerli` to re-add add your private key to goerli.deployments.txt.

<strong><pre>`    int(config.USER_ADDRESS, 16),  # felt
TypeError: int() can't convert non-string with explicit base`</pre></strong>

This error means that your user address (account-1) in the file goerli.deployments.txt is not being read correctly. Make sure your account-1 line is on its own line and contains the correct address. In some cases, the account-1 will be appended to an existing line so move it to its own line.


----


1. Export PK from Argent
2. Save as STARKNET_PRIVATE_KEY in env
3. `source realms_cli/.env.nile`
4. `python scripts/script.py`
5. Save the printed public key in the goerli.accounts.json in address-1
6. Copy your address from argent and save it in both goerli.accounts.json and in goerli.deployments.txt (replacing the account-1 address)
7. `pip install realms_cli/`