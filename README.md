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

    export PIIVAULT_HOSTNAME="localhost:9443"
    export PIIVAULT_ACCOUNTID=<subscription-account-id>
    export PIIVAULT_APIKEY=<subscription-account-apikey>

    rm getpolyidbulk-reponse.json

    ./curl-commands.sh --VERB login

    time ./curl-commands.sh --VERB GetPolyIdBulk --REQUEST ./test-profiles-100.1.json

    less getpolyidbulk-reponse.json

