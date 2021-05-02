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

# Lindsay
#
# SubscriptionId: 4e5d7305-0cc6-6d6b-6453-cc16be164e68
#
#
# Web Access https://piivault.web
# Email: llawrence.dev@gmail.com
# Password: HNYAHS6E
#
# API Access https://piivault.web.api
# AccountId: 2cb1211b-214a-728b-a40f-1939503ba153
# ApiKey: KGVgpjdXWtSmD0SzkeZio6rFXcWHmwZn
#
# Lindsay
#
# SubscriptionId: 4e5d7305-0cc6-6d6b-6453-cc16be164e68
#
#
# Web Access
# Email: lindsay@anonomatic.com
# Password: OPBN45JR
#
# API Access
# AccountId: 88fb13a4-b14d-b1fb-cac5-9da45ad29a51
# ApiKey: 3a98wl4UBxWpDTbDPF8DCLkaKe6Vfosb

HOSTNAME=localhost:62291
#JSON2SEND=sunder-test-10k.json

ACCOUNTID_1=a657eeb1-d28f-bf6b-2c05-01e0cf9f4a51
APIKEY_1=MdrG1FNgFHQDqHATJzjH7QfICRGmg1yu

ACCOUNTID_2=
APIKEY_2=

# ./curl-commands.sh --HOSTNAME "localhost:53043" --VERB PurgeAccountProfile --ACCOUNTID 88fb13a4-b14d-b1fb-cac5-9da45ad29a51 --APIKEY 3a98wl4UBxWpDTbDPF8DCLkaKe6Vfosb
# ./curl-commands.sh --HOSTNAME "localhost:53043" --VERB GetPolyIdBulk --ACCOUNTID 88fb13a4-b14d-b1fb-cac5-9da45ad29a51 --APIKEY 3a98wl4UBxWpDTbDPF8DCLkaKe6Vfosb --REQUEST sunder-test-10k.json
# ./curl-commands.sh --HOSTNAME "localhost:53043" --VERB Match --ACCOUNTID 88fb13a4-b14d-b1fb-cac5-9da45ad29a51 --APIKEY 3a98wl4UBxWpDTbDPF8DCLkaKe6Vfosb --REQUEST match-request.json
# ./curl-commands.sh --HOSTNAME "localhost:53043" --VERB GetProfilePseudonym --ACCOUNTID 88fb13a4-b14d-b1fb-cac5-9da45ad29a51 --APIKEY 3a98wl4UBxWpDTbDPF8DCLkaKe6Vfosb --REQUEST getprofilepseudonym-request.json

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
rm api-token.txt

curl -k \
	-X POST "https://${HOSTNAME}/api/auth/login" \
	-H "Content-Type: application/json" \
-d "{ \"AccountId\": \"${ACCOUNTID}\", \"ApiKey\": \"${APIKEY}\" }" \
> api-token.txt
exit

;;

esac

# 2. Copy the token from the JSON Payload of the above response to here (or use jq)
# NOTE: This uses https://stedolan.github.io/jq/ to set the API_TOKEN

API_TOKEN=$(jq -r ".Data.Token" api-token.txt)


# 3. Try out the apis below!
case $VERB in

GetPolyId)
## -- PUT GetPolyId --

echo
echo "START //${HOSTNAME}/api/profiles/GetPolyId: $(date)"
echo

curl -v \
 -X PUT "https://${HOSTNAME}/api/profiles/GetPolyId" \
 -H "Authorization: Bearer ${API_TOKEN}" \
 -H "Content-Type: application/json" \
 -H "Content-Type: application/json" -d @${REQUEST} > getpolyid-response.json

echo
echo "FINIS GetPolyId: $(date)"
echo

;;

GetPolyIdBulk)
## -- PUT PolyIdBulk --

echo
echo "START //${HOSTNAME}/api/profiles/GetPolyIdBulk: $(date)"
echo

curl -k \
 -X PUT "https://${HOSTNAME}/api/profiles/GetPolyIdBulk" \
 -H "Authorization: Bearer ${API_TOKEN}" \
 -H "Content-Type: application/json" \
 -H "Content-Type: application/json" -d @${REQUEST} | jq '.' > getpolyidbulk-reponse.json

echo
echo "FINIS GetPolyIdBulk: $(date)"
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
 -H "Content-Type: application/json" -d @${RESPONSE}

echo
echo "FINIS ForgetProfile: $(date)"
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
 -X POST "https://${HOSTNAME}/api/match" \
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
 -H "Authorization: Bearer ${API_TOKEN}" | jq '.' >  match-response.json

echo
echo "END   GetMatchList: $(date)"
echo

;;

GetProfileFromSourceKey)
## -- Generate match table --
echo
echo "START GetProfileFromSourceKey: $(date)"
echo

time curl -k \
 -X POST "https://${HOSTNAME}/api/profiles/GetProfileFromSourceKey" \
 -H "Authorization: Bearer ${API_TOKEN}" \
 -H "Content-Type: application/json" \
 -H "Content-Type: application/json" -d @${REQUEST} | jq '.'

echo
echo "END   GetProfileFromSourceKey: $(date)"
echo

;;

GetProfileFromPolyId)
## -- Generate match table --
echo
echo "START GetProfileFromPolyId: $(date)"
echo

time curl -k \
 -X POST "https://${HOSTNAME}/api/profiles/GetProfileFromPolyId" \
 -H "Authorization: Bearer ${API_TOKEN}" \
 -H "Content-Type: application/json" \
 -H "Content-Type: application/json" -d @${REQUEST} | jq '.'

echo
echo "END   GetProfileFromPolyId: $(date)"
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
 -H "Content-Type: application/json" -d @${REQUEST} | jq '.' > getprofilepseudonym-response.json

echo
echo "FINIS GetProfilePseudonym: $(date)"
echo

;;

*)

echo
echo "Unknown command verb; check source"
echo

;;

esac

