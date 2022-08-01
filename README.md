# Anonomatic PII Vault #
---

Examples of using the PIIVault APIs with cURL (see script files `piivault-curl.sh` and `passthrough-curl.sh` for details)

### PIIVault ###

An ``account id`` and ``api key`` for an active PII Vault subscription is required to run the examples.
You can create a Trial subscription at our [online demo instance](https://api.anonomatic.com/piivault/ui) or contact [Anonomatic Inc](https://anonomatic.com "PII Compliance made Easy") for an on-premise install.

---
#### PII Vault API documentation ####

[PII Vault Core API](https://{HOST}/piivault)

[PII Vault Passthrough API](https://{HOST}/passthrough)

#### PII Vault UI ####

[PII Vault Admin](https://HOSTNAME/piivault/ui) Manage subscriptions in given vault instance; create subscription with accounts and apikey

[PII Vault Passthrough](https://HOSTNAME/passthrough/ui) A reference implementation of using the Passthrough APIs

---
#### PIIVault Curl Example ####

The bash scripts require __cURL__ and __jq__. On debian based systems you can install these with

    sudo apt update
    sudo apt upgrade
    sudo apt install curl
    sudo apt install jq


Example of loading profile data into the vault


    export PIIVAULT_HOSTNAME="localhost:9443"
    export PIIVAULT_ACCOUNTID=<subscription-account-id>
    export PIIVAULT_APIKEY=<subscription-account-apikey>

    rm getpolyidbulk-reponse.json

    ./piivault-commands.sh --VERB login

    time ./piivault-curl.sh --VERB GetPolyIdBulk --REQUEST ./test-profiles-100.1.json

    less getpolyidbulk-reponse.json

#### See commands available in bash scripts. See scripts for details of parameters. ####

    grep -Ei "^\w+\)" piivault-curl.sh
    grep -Ei "^\w+\)" passthrough-curl.sh

