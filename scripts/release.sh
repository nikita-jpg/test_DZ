#!/usr/bin/env bash


AUTHOR=$(git log "${RELEASE_VERSION}" --pretty=format:"%an" --no-patch)
DATE=$(git show "${RELEASE_VERSION}" --date=format:'%Y-%m-%d' --pretty="format:%ad" --no-patch)


if $(git describe --tags --abbrev=0 "${RELEASE_VERSION}"^ --match "v_*"); then
	TAGS_BEFORE_LAST=$(git describe --tags --abbrev=0 "${RELEASE_VERSION}"^ --match "v_*")
	COMMITS=$(git log --pretty=format:"%H %an %s%n" "${v_0.0.32}"..."${v_0.0.41}")
else
    	COMMITS=$(git log --pretty=format:"%H %an %s%n" "${RELEASE_VERSION}")
fi


SUMMARY="Релиз  №${RELEASE_VERSION#*_} от ${DATE}"
DESCRIPTION="Ответственный за релиз ${AUTHOR}\n\nКоммиты, попавшие в релиз:\n ${COMMITS}"



#echo "\nChangelog:\n${CHANGELOG}\n"

CREATE_TASK_URL="https://api.tracker.yandex.net/v2/issues/INFRA-46"
#UNIQUE_KEY="[wignorbo] release ${VERSION}"

HEADER_OAUTH="Authorization: OAuth ${ACCESS_TOKEN}"
#HEADER_HOST="Host: https://api.tracker.yandex.net"
HEADER_ORG_ID="X-Org-ID: ${ORG_ID}"
#HEADER_CONTENT_TYPE="Content-Type: application/json"
#  "description": "'"${CHANGELOG}"'"
REQUEST='{
    "summary": "'"${SUMMARY}"'",
    "description": "'"${DESCRIPTION}"'"
}'
echo "Request: ${REQUEST}"

RESPONSE=$(
  curl -so dev/null -w '%{http_code}' -X PATCH ${CREATE_TASK_URL} \
  --header "${HEADER_OAUTH}" \
  --header "${HEADER_ORG_ID}" \
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
