# piivault-curl

Demo using PIIVault APIs with cURL (see curl-commands.sh for details)

For linux; ubuntun, debian based systems:

---- PIIVault Docker ----

You need to have access to a running vault. Contact Anonomatic if you don't already have one.

**API documentation**

https://{HOST}/piivault) -- PIIVault Core API
https://{HOST}/passthrough) -- PIIVault Passthrough API 

PIIVault UI

https://{HOST}/piivault/ui) -- Manage subscriptions in given vault instance; create subscription with accounts and apikey
https://{HOST}/passthrough/ui) -- A reference implementation of using the Passthrough APIs

---- PIIVault Curl Example ----

  export PIIVAULT_HOSTNAME="localhost:9443"
  export PIIVAULT_ACCOUNTID=<subscription-account-id>
  export PIIVAULT_APIKEY=<subscription-account-apikey>

  rm getpolyidbulk-reponse.json

  ./curl-commands.sh --VERB login

  time ./curl-commands.sh --VERB GetPolyIdBulk --REQUEST ./test-profiles-100.1.json

  less getpolyidbulk-reponse.json

