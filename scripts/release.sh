#!/usr/bin/env bash

#echo "${RELEASE_VERSION}"

VERSION=$(git tag --sort version:refname | tail -1 | head -1)
PREVIOUS_VERSION=$(git tag --sort version:refname | tail -2 | head -1)
echo "Current version: ${VERSION}"
echo "Previous version: ${PREVIOUS_VERSION}"

AUTHOR=$(git show "${VERSION}" --pretty=format:"%an" --no-patch)
DATE=$(git show "${VERSION}" --pretty=format:"%ad" --no-patch)
echo "${AUTHOR}: ${DATE}"

CHANGELOG=$(git log "$PREVIOUS_VERSION".. --pretty=format:"%s | %an, %ad" --date=short)
SUMMARY="${VERSION}: ${AUTHOR}, ${DATE}"
echo "\nChangelog:\n${CHANGELOG}\n"

CREATE_TASK_URL="https://api.tracker.yandex.net/v2/issues/INFRA-46"
UNIQUE_KEY="[wignorbo] release ${VERSION}"

HEADER_OAUTH="Authorization: OAuth ${ACCESS_TOKEN}"
HEADER_ORG_ID="X-Org-ID: ${ORG_ID}"
HEADER_CONTENT_TYPE="Content-Type: application/json"

REQUEST='{
  "summary": "'"${SUMMARY}"'",
  "description": "'"${CHANGELOG}"'",
  "queue": "TMP",
  "unique": "'"${UNIQUE_KEY}"'"
}'
echo "Request: ${REQUEST}"

RESPONSE=$(
  curl -so dev/null -w '%{http_code}' -X POST ${CREATE_TASK_URL} \
  --header "${HEADER_OAUTH}" \
  --header "${HEADER_ORG_ID}" \
  --header "${HEADER_CONTENT_TYPE}" \
  --data "${REQUEST}"
)
echo "Response: ${RESPONSE}."

if [ ${RESPONSE} = 200 ]; then
  echo "Published"
  exit 0
elif [ ${RESPONSE} = 401 ]; then
  echo "Auth Error"
  exit 1
elif [ ${RESPONSE} = 403 ]; then
  echo "Auth Error"
  exit 1
fi