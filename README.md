# piivault-curl
Demo using PIIVault APIs with cURL (see curl-commands.sh for details)

For linux; ubuntun, debian based systems:

---- PIIVault Docker ----

docker run --name piivaultapi -h piivaultapi -p 0.0.0.0:9443:443 -p 0.0.0.0:9480:80 -e "PIIVAULT_SECRETS_KEY=<secrets-key-from-anonomatic>" -e "ASPNETCORE_URLS=https://+:443;http://+:80" --detach anonomatic/piivaultwebapi:latest

https://localhost:9443/index.html -- Swagger API
  
https://localhost:9443/ui -- Manage subscriptions in given vault instance; create subscription with accounts and apikey

---- PIIVault Curl ----

  export PIIVAULT_HOSTNAME="localhost:9443"
  export PIIVAULT_ACCOUNTID=<subscription-account-id>
  export PIIVAULT_APIKEY=<subscription-account-apikey>

  rm getpolyidbulk-reponse.json

  ./curl-commands.sh --VERB login

  time ./curl-commands.sh --VERB GetPolyIdBulk --REQUEST ./test-profiles-100.1.json

  less getpolyidbulk-reponse.json

