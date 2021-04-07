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

# 1. Use the AccountId, and API Key provided by Anonomatic to get a Bearer Token

# -- POST login --
#curl \
#-X POST "https://api.piivault.com/api/auth/login" \
#-H "Content-Type: application/json" \
#-d '{ "AccountId": "[ Account ID ]", "ApiKey": "[ API Key ]" }' \
#> api-token.txt

# 2. Copy the token from the JSON Payload of the above response to here

API_TOKEN=YourApiTokenHere

# 3. Try out the apis below! 
# NOTE: Uncomment each curl command in turn

## -- PUT GetPolyId --

curl -v \
 -X PUT "https://api.piivault.com/api/profiles/GetPolyId" \
 -H "Authorization: Bearer ${API_TOKEN}" \
 -H "Content-Type: application/json" \
 -H "Content-Type: application/json" -d @test-profile-min.json

## -- PUT PolyIdBulk --

#curl -v \
# -X PUT "https://api.piivault.com/api/profiles/GetPolyIdBulk" \
# -H "Authorization: Bearer ${API_TOKEN}" \
# -H "Content-Type: application/json" \
# -H "Content-Type: application/json" -d @test-profiles.json

## -- PUT /api/profiles/ForgetProfile --

#curl -v \
# -X PUT "https://api.piivault.com/api/profiles/ForgetProfile" \
# -H "Authorization: Bearer ${API_TOKEN}" \
# -H "Content-Type: application/json" \
# -H "Content-Type: application/json" -d @test-forget-profile.json

## -- PUT PurgeAccountProfiles --

#curl -v \
#-X PUT "https://api.piivault.com/api/profiles/PurgeAccountProfiles" \
#-H "Authorization: Bearer ${API_TOKEN}" \
#-H "Content-Length: 0"

