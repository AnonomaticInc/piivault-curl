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

# ./curl-commands.sh --HOSTNAME "localhost:53043" --VERB PurgeAccountProfile --ACCOUNTID 88fb13a4-b14d-b1fb-cac5-9da45ad29a51 --APIKEY 3a98wl4UBxWpDTbDPF8DCLkaKe6Vfosb
# ./curl-commands.sh --HOSTNAME "localhost:53043" --VERB GetPolyIdBulk --ACCOUNTID 88fb13a4-b14d-b1fb-cac5-9da45ad29a51 --APIKEY 3a98wl4UBxWpDTbDPF8DCLkaKe6Vfosb --REQUEST sunder-test-10k.json
# ./curl-commands.sh --HOSTNAME "localhost:53043" --VERB Match --ACCOUNTID 88fb13a4-b14d-b1fb-cac5-9da45ad29a51 --APIKEY 3a98wl4UBxWpDTbDPF8DCLkaKe6Vfosb --REQUEST match-request.json
# ./curl-commands.sh --HOSTNAME "localhost:53043" --VERB GetProfilePseudonym --ACCOUNTID 88fb13a4-b14d-b1fb-cac5-9da45ad29a51 --APIKEY 3a98wl4UBxWpDTbDPF8DCLkaKe6Vfosb --REQUEST getprofilepseudonym-request.json

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
	-X POST "https://${HOSTNAME}/piivault/api/auth/login" \
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
	-X POST "https://${HOSTNAME}/piivault/api/auth/login" \
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

GetKeyTypes)

echo
echo "START //${HOSTNAME}/piivault/api/profiles/GetKeyTypes: $(date)"
echo

curl -k \
 -X GET "https://${HOSTNAME}/piivault/api/profiles/GetKeyTypes" \
 -H "Authorization: Bearer ${API_TOKEN}"  | jq '.'

echo
echo "FINIS GetKeyTypes: $(date)"
echo

;;

GetPolyId)
## -- PUT GetPolyId --

echo
echo "START //${HOSTNAME}/piivault/api/profiles/GetPolyId: $(date)"
echo

curl -k \
 -X PUT "https://${HOSTNAME}/piivault/api/profiles/GetPolyId" \
 -H "Authorization: Bearer ${API_TOKEN}" \
 -H "Content-Type: application/json" \
 -H "Content-Type: application/json" -d @${REQUEST}  | jq '.' > ./response-data/getpolyid-response.json

echo
echo "FINIS GetPolyId: $(date)"
echo

cat ./response-data/getpolyid-response.json

;;

GetPolyIdBulk)
## -- PUT PolyIdBulk --

echo
echo "START //${HOSTNAME}/piivault/api/profiles/GetPolyIdBulk: $(date)"
echo

curl -s -k --compressed \
 -X PUT "https://${HOSTNAME}/piivault/api/profiles/GetPolyIdBulk" \
 -H "Authorization: Bearer ${API_TOKEN}" \
 -H "Content-Type: application/json" \
 -H "Content-Type: application/json" -d @${REQUEST} | jq '.' > ./response-data/getpolyidbulk-response.json

head -n 25 ./response-data/getpolyidbulk-response.json

echo
echo "FINIS GetPolyIdBulk: $(date)"
echo

;;

GetPolyIdWithPseudonym)
## -- PUT PolyIdBulk --

echo
echo "START //${HOSTNAME}/piivault/api/profiles/GetPolyIdWithPseudonym: $(date)"
echo

rm -f ./reponse-data/getpolyid-response.json

curl -s -k --compressed \
 -X PUT "https://${HOSTNAME}/piivault/api/profiles/GetPolyIdWithPseudonym" \
 -H "Authorization: Bearer ${API_TOKEN}" \
 -H "Content-Type: application/json" \
 -H "Content-Type: application/json" -d @${REQUEST} | jq '.' > ./response-data/getpolyid-response.json

head -n 25 ./response-data/getpolyid-response.json

echo
echo "FINIS GetPolyIdWithPseudonym: $(date)"
echo

;;

GetPolyIdWithPseudonymBulk)
## -- PUT PolyIdBulk --

echo
echo "START //${HOSTNAME}/piivault/api/profiles/GetPolyIdWithPseudonymBulk: $(date)"
echo

rm -f ./response-data/getpolyidwithpseudonym-response.json

curl -s -k --compressed \
 -X PUT "https://${HOSTNAME}/piivault/api/profiles/GetPolyIdWithPseudonymBulk" \
 -H "Authorization: Bearer ${API_TOKEN}" \
 -H "Content-Type: application/json" \
 -H "Content-Type: application/json" -d @${REQUEST} | jq '.' > ./response-data/getpolyidpseudonym-reponse.json

head -n 25 ./response-data/getpolyidpseudonym-reponse.json

echo
echo "FINIS GetPolyIdWithPseudonymBulk: $(date)"
echo

;;

ForgetProfile)
#  -- PUT /piivault/api/profiles/ForgetProfile --

echo
echo "START /piivault/api/profiles/ForgetProfile: $(date)"
echo

curl -k \
 -X PUT "https://${HOSTNAME}/piivault/api/profiles/ForgetProfile" \
 -H "Authorization: Bearer ${API_TOKEN}" \
 -H "Content-Type: application/json" \
 -H "Content-Type: application/json" -d @${REQUEST}

echo
echo "FINIS ForgetProfile: $(date)"
echo

;;

DeleteProfile)
#  -- PUT /piivault/api/profiles/ForgetProfile --

echo
echo "START /piivault/api/profiles/DeleteProfile: $(date)"
echo

curl -k \
 -X PUT "https://${HOSTNAME}/piivault/api/profiles/DeleteProfile" \
 -H "Authorization: Bearer ${API_TOKEN}" \
 -H "Content-Type: application/json" \
 -H "Content-Type: application/json" -d @${REQUEST}

echo
echo "FINIS DeleteProfile: $(date)"
echo

;;

PurgeAccountProfile)
## -- PUT PurgeAccountProfiles --

echo
echo "START /piivault/api/profiles/PurgeAccountProfiles: $(date)"
echo

curl -k \
-X PUT "https://${HOSTNAME}/piivault/api/profiles/PurgeAccountProfiles" \
-H "Authorization: Bearer ${API_TOKEN}" \
-H "Content-Length: 0"

echo
echo "FINIS PurgeAccountProfiles: $(date)"
echo

;;

CancelMatchTask)
## -- Generate match table --
echo
echo "START CancelMatchTask: $(date)"
echo

time curl -k \
 -X PUT "https://${HOSTNAME}/piivault/api/match/CancelMatchTask" \
 -H "Authorization: Bearer ${API_TOKEN}" \
 -H "Content-Type: application/json" \
 -H "Content-Length: 0" | jq '.' > ./response-data/execute-match.json

echo
echo "END   CancelMatchTask: $(date)"
echo

;;

ExecuteMatch)
## -- Generate match table --
echo
echo "START ExecuteMatchTask: $(date)"
echo

time curl -k \
 -X POST "https://${HOSTNAME}/piivault/api/match" \
 -H "Authorization: Bearer ${API_TOKEN}" \
 -H "Content-Type: application/json" \
 -H "Content-Type: application/json" -d @${REQUEST} | jq '.' > ./response-data/execute-match.json

echo
echo "END   ExecuteMatchTask: $(date)"
echo

head -n 25 ./response-data/execute-match.json

;;

TestMatch)
## -- Generate match table --
echo
echo "START TestMatchTask: $(date)"
echo

time curl -k \
 -X PUT "https://${HOSTNAME}/piivault/api/match/TestMatchTask" \
 -H "Authorization: Bearer ${API_TOKEN}" \
 -H "Content-Type: application/json" \
 -H "Content-Type: application/json" -d @${REQUEST} | jq '.' > ./response-data/test-match.json

echo
echo "END   TestMatchTask: $(date)"
echo

head -n 25 ./response-data/test-match.json

;;

GetMatchTaskResult)

## -- Get  match table --
echo
echo "START GetMatchTaskResult)"
echo

curl -k \
 "https://${HOSTNAME}/piivault/api/match" \
 -H "Authorization: Bearer ${API_TOKEN}" | jq '.' >  ./response-data/match-response.json

echo
echo "END   GetMatchTaskResult: $(date)"
echo

head -n 25 ./response-data/match-response.json

;;


GetMatchTaskStatus)

## -- Get  match table --
echo
echo "START GetMatchTaskStatus: $(date)"
echo

curl -k \
 "https://${HOSTNAME}/piivault/api/match/GetMatchTaskStatus" \
 -H "Authorization: Bearer ${API_TOKEN}" # | jq '.' >  ./response-data/match-status-response.json

echo
echo "END   GetMatchTaskStatus: $(date)"
echo

;;

GetSecondaryPolyId)
## -- Generate match table --
echo
echo "START GetSecondaryPolyId: $(date)"
echo

time curl -k -v \
 -X PUT "https://${HOSTNAME}/piivault/api/profiles/GetSecondaryPolyId" \
 -H "Authorization: Bearer ${API_TOKEN}" \
 -H "Content-Type: application/json" \
 -H "Content-Type: application/json"  -d @${REQUEST} | jq '.' > ./response-data/getsecondarypolyid-response.json

head -n 25 ./response-data/getsecondarypolyid-response.json

echo
echo "END   GetSecondaryPolyId: $(date)"
echo

;;


GetProfileBySourceSystemKey)
## -- Generate match table --
echo
echo "START GetProfileBySourceSystemKey: $(date)"
echo

time curl -v -k \
 -X PUT "https://${HOSTNAME}/piivault/api/profiles/GetProfile" \
 -H "Authorization: Bearer ${API_TOKEN}" \
 -H "Content-Type: application/json" \
 -H "Content-Type: application/json" -d "{ \"SourceSystemKey\": \"${ID}\" }" | jq '.' > ./response-data/getprofile-response.json

cat ./response-data/getprofile-response.json

echo
echo "END   GetProfileBySourceSystemKey: $(date)"
echo

;;

GetProfile)
## -- Generate match table --
echo
echo "START GetProfile: $(date)"
echo

time curl -v -k \
 -X PUT "https://${HOSTNAME}/piivault/api/profiles/GetProfile" \
 -H "Authorization: Bearer ${API_TOKEN}" \
 -H "Content-Type: application/json" \
 -H "Content-Type: application/json" -d "{ \"PolyId\": \"${ID}\" }" | jq '.' > ./response-data/getprofile-response.json

cat ./response-data/getprofile-response.json

echo
echo "END   GetProfile: $(date)"
echo

;;

GetProfilePseudonymByPolyId)

echo
echo "START //${HOSTNAME}/piivault/api/profiles/GetProfilePseudonym: $(date)"
echo

time curl -k \
 -X PUT "https://${HOSTNAME}/piivault/api/profiles/GetProfilePseudonym" \
 -H "Authorization: Bearer ${API_TOKEN}" \
 -H "Content-Type: application/json" \
 -H "Content-Type: application/json"  -d "{ \"PolyId\": \"${POLYID}\", \"Seed\": ${SEED:-37} }" | jq '.' > ./response-data/getprofilepseudonym-response.json


cat ./response-data/getprofilepseudonym-response.json

echo
echo "FINIS GetProfilePseudonym: $(date)"
echo

;;

GetProfilePseudonymBySourceSystemKey)

echo
echo "START //${HOSTNAME}/piivault/api/profiles/GetProfilePseudonym: $(date)"
echo

time curl -k \
 -X PUT "https://${HOSTNAME}/piivault/api/profiles/GetProfilePseudonym" \
 -H "Authorization: Bearer ${API_TOKEN}" \
 -H "Content-Type: application/json" \
 -H "Content-Type: application/json"  -d "{ \"SourceSystemKey\": \"${PROFILEID}\" }" | jq '.' > ./response-data/getprofilepseudonym-response.json


cat ./response-data/getprofilepseudonym-response.json

echo
echo "FINIS GetProfilePseudonym: $(date)"
echo

;;

RedactText)

echo
echo "START //${HOSTNAME}/piivault/api/profiles/RedactText: $(date)"
echo

time curl -k \
 -X POST "https://${HOSTNAME}/piivault/api/profiles/RedactText" \
 -H "Authorization: Bearer ${API_TOKEN}" \
 -H "Content-Type: application/json" \
 -H "Content-Type: application/json" -d @${REQUEST} | jq '.' > ./response-data/redact-response.json

echo
echo "FINIS RedactText: $(date)"
echo

cat ./response-data/redact-response.json

;;

# -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
GetSchemaById)

echo
echo "START //${HOSTNAME}/piivault/api/schema/GetSchema/${SCHEMAID}"
echo

time curl -k \
 -X GET "https://${HOSTNAME}/piivault/api/schema/GetSchema/${SCHEMAID}" \
 -H "Authorization: Bearer ${API_TOKEN}" \
 -H "Content-Type: application/json" | jq '.' > ./response-data/getschema-response.json

echo
echo "FINIS GetSchema"
echo

cat ./response-data/getschema-response.json

;;

GetSchemaByName)

echo
echo "START //${HOSTNAME}/piivault/api/schema/GetSchema/${SCHEMAGROUP}/${SCHEMASUBGROUP}/${SCHEMANAME}"
echo

time curl -k \
 -X GET "https://${HOSTNAME}/piivault/api/schema/GetSchema/${SCHEMAGROUP}/${SCHEMASUBGROUP}/${SCHEMANAME}" \
 -H "Authorization: Bearer ${API_TOKEN}" \
 -H "Content-Type: application/json" | jq '.' > ./response-data/getschema-response.json

echo
echo "FINIS GetSchema"
echo

cat ./response-data/getschema-response.json

;;

GetSchemaGroups)

echo
echo "START //${HOSTNAME}/piivault/api/schema/GetSchemaGroups"
echo

time curl -k \
 -X GET "https://${HOSTNAME}/piivault/api/schema/GetSchemaGroups" \
 -H "Authorization: Bearer ${API_TOKEN}" \
 -H "Content-Type: application/json" | jq '.' > ./response-data/getschema-response.json

echo
echo "FINIS GetSchemaGroups"
echo

cat ./response-data/getschema-response.json

;;

GetSchemaSubGroups)

echo
echo "START //${HOSTNAME}/piivault/api/schema/GetSchemaSubGroups/${SCHEMAGROUP}"
echo

time curl -k \
 -X GET "https://${HOSTNAME}/piivault/api/schema/GetSchemaSubGroups/${SCHEMAGROUP}" \
 -H "Authorization: Bearer ${API_TOKEN}" \
 -H "Content-Type: application/json" | jq '.' > ./response-data/getschema-response.json

echo
echo "FINIS GetSchemaSubGroups"
echo

cat ./response-data/getschema-response.json

;;

GetSchemaGroup)

echo
echo "START //${HOSTNAME}/piivault/api/schema/GetSchemaGroup/${SCHEMAGROUP}"
echo

time curl -k \
 -X GET "https://${HOSTNAME}/piivault/api/schema/GetSchemaGroup/${SCHEMAGROUP}" \
 -H "Authorization: Bearer ${API_TOKEN}" \
 -H "Content-Type: application/json" | jq '.' > ./response-data/getschema-response.json

echo
echo "FINIS GetSchemaGroup"
echo

cat ./response-data/getschema-response.json

;;

GetSchemaSubGroup)

echo
echo "START //${HOSTNAME}/piivault/api/schema/GetSchemaSubGroup/${SCHEMAGROUP}/${SCHEMASUBGROUP}"
echo

time curl -k \
 -X GET "https://${HOSTNAME}/piivault/api/schema/GetSchemaSubGroup/${SCHEMAGROUP}/${SCHEMASUBGROUP}" \
 -H "Authorization: Bearer ${API_TOKEN}" \
 -H "Content-Type: application/json" | jq '.' > ./response-data/getschema-response.json

echo
echo "FINIS GetSchemaSubGroup"
echo

cat ./response-data/getschema-response.json

;;

GetAllSchema)

echo
echo "START //${HOSTNAME}/piivault/api/schema/GetAllSchema"
echo

time curl -k \
 -X GET "https://${HOSTNAME}/piivault/api/schema/GetAllSchema" \
 -H "Authorization: Bearer ${API_TOKEN}" \
 -H "Content-Type: application/json" | jq '.' > ./response-data/getallschema-response.json

echo
echo "FINIS GetAllSchema"
echo

cat ./response-data/getallschema-response.json

;;

AddSchema)

echo
echo "START //${HOSTNAME}/piivault/api/schema/AddSchema"
echo

time curl -k \
 -X POST "https://${HOSTNAME}/piivault/api/schema/AddSchema" \
 -H "Authorization: Bearer ${API_TOKEN}" \
 -H "Content-Type: application/json" -d @${REQUEST} | jq '.' > ./response-data/addschema-response.json

echo
echo "FINIS AddSchema"
echo

cat ./response-data/addschema-response.json

;;

UpdateSchema)

echo
echo "START //${HOSTNAME}/piivault/api/schema/UpdateSchema"
echo

time curl -k \
 -X PUT "https://${HOSTNAME}/piivault/api/schema/UpdateSchema" \
 -H "Authorization: Bearer ${API_TOKEN}" \
 -H "Content-Type: application/json" -d @${REQUEST} | jq '.' > ./response-data/updateschema-response.json

echo
echo "FINIS UpdateSchema"
echo

cat ./response-data/updateschema-response.json

;;

DeleteSchema)

echo
echo "START //${HOSTNAME}/piivault/api/schema/DeleteSchema/${SCHEMAID}"
echo

time curl -k \
 -X PUT "https://${HOSTNAME}/piivault/api/schema/DeleteSchema/${SCHEMAID}" \
 -H "Authorization: Bearer ${API_TOKEN}" \
 -H "Content-Type: application/json"  | jq '.' > ./response-data/deleteschema-response.json

echo
echo "FINIS DeleteSchema"
echo

cat ./response-data/deleteschema-response.json

;;

*)

echo
echo "Unknown command verb; check source"
echo

;;

esac

