#!/usr/bin/env bash
# https://kvz.io/bash-best-practices.html
# Bash3 Boilerplate. Copyright (c) 2014, kvz.io

set -o errexit
set -o pipefail
#set -o nounset
#set -o xtrace  # echo each line executed

# Set magic variables for current file & dir
__dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
__file="${__dir}/$(basename "${BASH_SOURCE[0]}")"
__base="$(basename ${__file} .sh)"
__root="$(cd "$(dirname "${__dir}")" && pwd)" # <-- change this as it depends on your app

#arg1="${1:-}"

# export PIIVAULT_HOSTNAME="localhost"
# export PIIVAULT_ACCOUNTID=9a183ae2-a472-eb2b-6103-f3e11adaed61
# export PIIVAULT_APIKEY=UyGr87k2wRFy9vTudhi6IaPa10ZugHut
# ./curl-commands.sh --VERB login
# ./curl-commands.sh --VERB login && time ./curl-commands.sh --VERB GetPolyIdBulk --REQUEST ./request-data/test-profiles-1000.1.json 

HOSTP=http
HOSTNAME=${PIIVAULT_HOSTNAME}
ACCOUNTID=${PIIVAULT_ACCOUNTID}
APIKEY=${PIIVAULT_APIKEY}
SUNDERID=${PIIVAULT_SUNDERID}

while [ $# -gt 0 ]; do

   if [[ $1 == *"--"* ]]; then
        param="${1/--/}"
        declare $param="$2"
        echo $1 $2
   fi

  shift
done

case $VERB in

login)
# 1. Use the AccountId, and API Key provided by Anonomatic to get a Bearer Token
# -- POST login --
rm -f api-token.txt

curl -k \
	-X POST "${HOSTP}://${HOSTNAME}/passthrough/api/auth/login" \
	-H "Content-Type: application/json" \
-d "{ \"AccountId\": \"${ACCOUNTID}\", \"ApiKey\": \"${APIKEY}\" }" \
> api-token.txt

echo -- -- -- -- API TOKEN -- -- -- --
cat api-token.txt
echo
echo -- -- -- -- API TOKEN -- -- -- --

exit


;;

loginWithSunder)
# 1. Use the AccountId, and API Key provided by Anonomatic to get a Bearer Token
# -- POST login --
rm -f api-token.txt

curl -k \
	-X POST "${HOSTP}://${HOSTNAME}/passthrough/api/auth/login" \
	-H "Content-Type: application/json" \
-d "{ \"AccountId\": \"${ACCOUNTID}\", \"ApiKey\": \"${APIKEY}\", \"SunderId\": \"${SUNDERID}\" }" \
> api-token.txt

echo -- -- -- -- API TOKEN -- -- -- --
cat api-token.txt
echo
echo -- -- -- -- API TOKEN -- -- -- --

exit


;;

esac

# 2. Copy the token from the JSON Payload of the above response to here (or use jq)
# NOTE: This uses https://stedolan.github.io/jq/ to set the API_TOKEN

API_TOKEN=$(jq -r ".Data.Token" api-token.txt)


# 3. Try out the apis below!
case $VERB in

# -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
DeleteSchema)

echo
echo "START //${HOSTNAME}/passthrough/api/schema/DeleteSchema/${SCHEMAID}"
echo

time curl -k \
 -X PUT "${HOSTP}://${HOSTNAME}/passthrough/api/schema/DeleteSchema/${SCHEMAID}" \
 -H "Authorization: Bearer ${API_TOKEN}" \
 -H "Content-Type: application/json" | jq '.' > ./response-data/deleteschema-response.json

echo
echo "FINIS DeleteSchema"
echo

cat ./response-data/deleteschema-response.json

;;

GetSchemaById)

echo
echo "START //${HOSTNAME}/passthrough/api/schema/GetSchema/${SCHEMAID}"
echo

time curl -k \
 -X GET "${HOSTP}://${HOSTNAME}/passthrough/api/schema/GetSchema/${SCHEMAID}" \
 -H "Authorization: Bearer ${API_TOKEN}" \
 -H "Content-Type: application/json" | jq '.' > ./response-data/getschema-response.json

echo
echo "FINIS GetSchema"
echo

cat ./response-data/getschema-response.json

;;

GetSchemaDictionary)

echo
echo "START //${HOSTNAME}/passthrough/api/GetSchemaDictionary"
echo

time curl -k \
 -X GET "${HOSTP}://${HOSTNAME}/passthrough/api/schema/GetSchemaDictionary" \
 -H "Authorization: Bearer ${API_TOKEN}" \
 -H "Content-Type: application/json" | jq '.' > ./response-data/getschemadictionary-response.json

echo
echo "FINIS GetSchema"
echo

cat ./response-data/getschemadictionary-response.json

;;

GetAllSchemas)

echo
echo "START //${HOSTNAME}/passthrough/api/schema/GetAllSchemas"
echo

time curl -k \
 -X GET "${HOSTP}://${HOSTNAME}/passthrough/api/schema/GetAllSchemas" \
 -H "Authorization: Bearer ${API_TOKEN}" \
 -H "Content-Type: application/json" | jq '.' > ./response-data/getallschemas-response.json

echo
echo "FINIS GetAllSchemas"
echo

cat ./response-data/getallschemas-response.json

;;

ListSchemaById)

echo
echo "START //${HOSTNAME}/passthrough/api/schema/ListSchema/${SCHEMAID}"
echo

time curl -k \
 -X GET "${HOSTP}://${HOSTNAME}/passthrough/api/schema/ListSchema/${SCHEMAID}" \
 -H "Authorization: Bearer ${API_TOKEN}" \
 -H "Content-Type: application/json" | jq '.' > ./response-data/listschema-response.json

echo
echo "FINIS ListSchema"
echo

cat ./response-data/listschema-response.json

;;

ListAllSchemas)

echo
echo "START //${HOSTNAME}/passthrough/api/schema/ListAllSchemas"
echo

time curl -k \
 -X GET "${HOSTP}://${HOSTNAME}/passthrough/api/schema/ListAllSchemas" \
 -H "Authorization: Bearer ${API_TOKEN}" \
 -H "Content-Type: application/json" | jq '.' > ./response-data/listallschemas-response.json

echo
echo "FINIS ListAllSchemas"
echo

cat ./response-data/listallschemas-response.json

;;

ValidateSchema)

echo
echo "START //${HOSTNAME}/passthrough/api/schema/ValidateSchema"
echo

time curl -k \
 -X POST "${HOSTP}://${HOSTNAME}/passthrough/api/schema/ValidateSchema" \
 -H "Authorization: Bearer ${API_TOKEN}" \
 -H "Content-Type: application/json" -d @${REQUEST} | jq '.' > ./response-data/validateschema-response.json

echo
echo "FINIS ValidateSchema"
echo

cat ./response-data/validateschema-response.json

;;

SaveSchema)

echo
echo "START //${HOSTNAME}/passthrough/api/schema/SaveSchema"
echo

time curl -k \
 -X POST "${HOSTP}://${HOSTNAME}/passthrough/api/schema/SaveSchema" \
 -H "Authorization: Bearer ${API_TOKEN}" \
 -H "Content-Type: application/json" -d @${REQUEST} | cat | jq '.' > ./response-data/saveschema-response.json

echo
echo "FINIS SaveSchema"
echo

cat ./response-data/saveschema-response.json

;;

PassthroughAnonymize)

echo
echo "START //${HOSTNAME}/passthrough/api/profiles/PassthroughAnonymize"
echo

time curl -k \
 -X POST "${HOSTP}://${HOSTNAME}/passthrough/api/profiles/PassthroughAnonymize" \
 -H "Authorization: Bearer ${API_TOKEN}" \
 -H "Content-Type: application/json" -d @${REQUEST} | jq '.' > ./response-data/passthroughanonymize-response.json

echo
echo "FINIS PassthroughAnonymize"
echo

cat ./response-data/passthroughanonymize-response.json

;;

PassthroughMask)

echo
echo "START //${HOSTNAME}/passthrough/api/profiles/PassthroughMask"
echo

time curl -k \
 -X POST "${HOSTP}://${HOSTNAME}/passthrough/api/profiles/PassthroughMask" \
 -H "Authorization: Bearer ${API_TOKEN}" \
 -H "Content-Type: application/json" -d @${REQUEST} | jq '.' > ./response-data/passthroughmask-response.json

echo
echo "FINIS PassthroughMask"
echo

cat ./response-data/passthroughanonymize-response.json

;;

PassthroughReIdentify)

echo
echo "START //${HOSTNAME}/passthrough/api/profiles/PassthroughReIdentify"
echo

time curl -k \
 -X POST "${HOSTP}://${HOSTNAME}/passthrough/api/profiles/PassthroughReIdentify" \
 -H "Authorization: Bearer ${API_TOKEN}" \
 -H "Content-Type: application/json" -d @${REQUEST} | cat | jq '.' > ./response-data/passthroughreidentify-response.json

echo
echo "FINIS PassthroughReIdentify"
echo

cat ./response-data/passthroughreidentify-response.json

;;




*)

echo
echo "Unknown command verb; check source"
echo

;;

esac

