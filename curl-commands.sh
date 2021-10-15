#!/usr/bin/env bash
# https://kvz.io/bash-best-practices.html
# Bash3 Boilerplate. Copyright (c) 2014, kvz.io

set -o errexit
set -o pipefail
set -o nounset
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
	-X POST "https://${HOSTNAME}/api/auth/login" \
	-H "Content-Type: application/json" \
-d "{ \"AccountId\": \"${ACCOUNTID}\", \"ApiKey\": \"${APIKEY}\" }" \
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
echo "START //${HOSTNAME}/api/profiles/GetKeyTypes: $(date)"
echo

curl -k \
 -X GET "https://${HOSTNAME}/api/profiles/GetKeyTypes" \
 -H "Authorization: Bearer ${API_TOKEN}"  | jq '.'

echo
echo "FINIS GetKeyTypes: $(date)"
echo

;;

GetPolyId)
## -- PUT GetPolyId --

echo
echo "START //${HOSTNAME}/api/profiles/GetPolyId: $(date)"
echo

curl -k \
 -X PUT "https://${HOSTNAME}/api/profiles/GetPolyId" \
 -H "Authorization: Bearer ${API_TOKEN}" \
 -H "Content-Type: application/json" \
 -H "Content-Type: application/json" -d @${REQUEST}  | jq '.' > ./response-data/getpolyid-response.json

echo
echo "FINIS GetPolyId: $(date)"
echo

;;

GetPolyIdBulk)
## -- PUT PolyIdBulk --

echo
echo "START //${HOSTNAME}/api/profiles/GetPolyIdBulk: $(date)"
echo

curl -s -k --compressed \
 -X PUT "https://${HOSTNAME}/api/profiles/GetPolyIdBulk" \
 -H "Authorization: Bearer ${API_TOKEN}" \
 -H "Content-Type: application/json" \
 -H "Content-Type: application/json" -d @${REQUEST} | jq '.' > ./response-data/getpolyidbulk-reponse.json

echo
echo "FINIS GetPolyIdBulk: $(date)"
echo

;;

GetPolyIdWithPseudonym)
## -- PUT PolyIdBulk --

echo
echo "START //${HOSTNAME}/api/profiles/GetPolyIdWithPseudonym: $(date)"
echo

rm -f ./reponse-data/getpolyid-response.json

curl -s -k -v --compressed \
 -X PUT "https://${HOSTNAME}/api/profiles/GetPolyIdWithPseudonym" \
 -H "Authorization: Bearer ${API_TOKEN}" \
 -H "Content-Type: application/json" \
 -H "Content-Type: application/json" -d @${REQUEST} | jq '.' > ./response-data/getpolyid-reponse.json

head -n 200 ./response-data/getpolyid-response.json

echo
echo "FINIS GetPolyIdWithPseudonym: $(date)"
echo

;;

GetPolyIdWithPseudonymBulk)
## -- PUT PolyIdBulk --

echo
echo "START //${HOSTNAME}/api/profiles/GetPolyIdWithPseudonymBulk: $(date)"
echo

rm -f ./response-data/getpolyidwithpseudonym-response.json

curl -s -k --compressed \
 -X PUT "https://${HOSTNAME}/api/profiles/GetPolyIdWithPseudonymBulk" \
 -H "Authorization: Bearer ${API_TOKEN}" \
 -H "Content-Type: application/json" \
 -H "Content-Type: application/json" -d @${REQUEST} | jq '.' > ./response-data/getpolyidpseudonym-reponse.json

head -n 200 ./response-data/getpolyidpseudonym-reponse.json

echo
echo "FINIS GetPolyIdWithPseudonymBulk: $(date)"
echo

;;

ForgetProfile)
#  -- PUT /api/profiles/ForgetProfile --

echo
echo "START /api/profiles/ForgetProfile: $(date)"
echo

curl -k \
 -X PUT "https://${HOSTNAME}/api/profiles/ForgetProfile" \
 -H "Authorization: Bearer ${API_TOKEN}" \
 -H "Content-Type: application/json" \
 -H "Content-Type: application/json" -d @${REQUEST}

echo
echo "FINIS ForgetProfile: $(date)"
echo

;;

DeleteProfile)
#  -- PUT /api/profiles/ForgetProfile --

echo
echo "START /api/profiles/DeleteProfile: $(date)"
echo

curl -k \
 -X PUT "https://${HOSTNAME}/api/profiles/DeleteProfile" \
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
echo "START /api/profiles/PurgeAccountProfiles: $(date)"
echo

curl -k \
-X PUT "https://${HOSTNAME}/api/profiles/PurgeAccountProfiles" \
-H "Authorization: Bearer ${API_TOKEN}" \
-H "Content-Length: 0"

echo
echo "FINIS PurgeAccountProfiles: $(date)"
echo

;;

Match)
## -- Generate match table --
echo
echo "START GenerateMatchTable: $(date)"
echo

time curl -k \
 -X POST "https://${HOSTNAME}/api/match?test=1" \
 -H "Authorization: Bearer ${API_TOKEN}" \
 -H "Content-Type: application/json" \
 -H "Content-Type: application/json" -d @${REQUEST}

echo
echo "END   GenerateMatchTable: $(date)"
echo


## -- Get  match table --
echo
echo "START GetMatchList: $(date)"
echo

curl -k \
 "https://${HOSTNAME}/api/match" \
 -H "Authorization: Bearer ${API_TOKEN}" | jq '.' >  ./response-data/match-response.json

echo
echo "END   GetMatchList: $(date)"
echo

head -n 200 ./response-data/match-response.json
;;

GetProfile)
## -- Generate match table --
echo
echo "START GetProfile: $(date)"
echo

time curl -k \
 -X POST "https://${HOSTNAME}/api/profiles/GetProfile" \
 -H "Authorization: Bearer ${API_TOKEN}" \
 -H "Content-Type: application/json" \
 -H "Content-Type: application/json" -d @${REQUEST} | jq '.' > ./response-data/getprofile-response.json

cat ./response-data/getprofile-response.json

echo
echo "END   GetProfile: $(date)"
echo

;;

GetProfilePseudonym)

echo
echo "START //${HOSTNAME}/api/profiles/GetProfilePseudonym: $(date)"
echo

time curl -k \
 -X PUT "https://${HOSTNAME}/api/profiles/GetProfilePseudonym" \
 -H "Authorization: Bearer ${API_TOKEN}" \
 -H "Content-Type: application/json" \
 -H "Content-Type: application/json" -d @${REQUEST} | jq '.' > ./response-data/getprofilepseudonym-response.json


cat ./response-data/getprofilepseudonym-response.json

echo
echo "FINIS GetProfilePseudonym: $(date)"
echo

;;

RedactText)

echo
echo "START //${HOSTNAME}/api/profiles/RedactText: $(date)"
echo

time curl -k \
 -X POST "https://${HOSTNAME}/api/profiles/RedactText" \
 -H "Authorization: Bearer ${API_TOKEN}" \
 -H "Content-Type: application/json" \
 -H "Content-Type: application/json" -d @${REQUEST} | jq '.' > ./response-data/redact-response.json

echo
echo "FINIS RedactText: $(date)"
echo

cat ./response-data/redact-response.json

;;

# -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
GetSchema)

echo
echo "START //${HOSTNAME}/api/schema/GetSchema/${NAMEORID}"
echo

time curl -k \
 -X GET "https://${HOSTNAME}/api/schema/GetSchema/${NAMEORID}" \
 -H "Authorization: Bearer ${API_TOKEN}" \
 -H "Content-Type: application/json" | jq '.' > ./response-data/getschema-response.json

echo
echo "FINIS GetSchema"
echo

cat ./response-data/getschema-response.json

;;

GetAllSchema)

echo
echo "START //${HOSTNAME}/api/schema/GetAllSchema"
echo

time curl -k \
 -X GET "https://${HOSTNAME}/api/schema/GetAllSchema" \
 -H "Authorization: Bearer ${API_TOKEN}" \
 -H "Content-Type: application/json" | jq '.' > ./response-data/getallschema-response.json

echo
echo "FINIS GetAllSchema"
echo

cat ./response-data/getallschema-response.json

;;

AddSchema)

echo
echo "START //${HOSTNAME}/api/schema/AddSchema"
echo

time curl -k \
 -X POST "https://${HOSTNAME}/api/schema/AddSchema" \
 -H "Authorization: Bearer ${API_TOKEN}" \
 -H "Content-Type: application/json" -d @${REQUEST} | jq '.' > ./response-data/addschema-response.json

echo
echo "FINIS AddSchema"
echo

cat ./response-data/addschema-response.json

;;

UpdateSchema)

echo
echo "START //${HOSTNAME}/api/schema/UpdateSchema"
echo

time curl -k \
 -X PUT "https://${HOSTNAME}/api/schema/UpdateSchema" \
 -H "Authorization: Bearer ${API_TOKEN}" \
 -H "Content-Type: application/json" -d @${REQUEST} | jq '.' > ./response-data/updateschema-response.json

echo
echo "FINIS UpdateSchema"
echo

cat ./response-data/updateschema-response.json

;;

DeleteSchema)

echo
echo "START //${HOSTNAME}/api/schema/DeleteSchema/${NAMEORID}"
echo

time curl -k \
 -X PUT "https://${HOSTNAME}/api/schema/DeleteSchema/${NAMEORID}" \
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

