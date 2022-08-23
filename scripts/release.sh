#!/usr/bin/env bash


AUTHOR=$(git show "${RELEASE_VERSION}" --pretty=format:"%an" --no-patch)
DATE=$(git show "${RELEASE_VERSION}" --date=format:'%Y-%m-%d' --pretty="format:%ad" --no-patch)

COMMITS="Bad request"


if git show-ref --tags "$(git describe --tags --abbrev=0 "${RELEASE_VERSION}^" --match="v_*")" --quiet; then
	echo "i am in if"
	TAGS_BEFORE_LAST=$(git describe --tags --abbrev=0 "${RELEASE_VERSION}^" --match="v_*")
	COMMITS=$(git log --pretty=format:"%H %an %s" "${TAGS_BEFORE_LAST}"..."${RELEASE_VERSION}")
else
  	echo "i am in else"
    COMMITS=$(git log --pretty=format:"%H %an %s" "${RELEASE_VERSION}")
fi

echo "$COMMITS" > in.txt
perl -pi -e 's/\n/\\n/g' in.txt
COMMITS=$(cat in.txt)

echo "${COMMITS}"
echo "RELEASE_VERSION: ${RELEASE_VERSION}"

SUMMARY="Релиз  №${RELEASE_VERSION#*-} от ${DATE}"
DESCRIPTION="**Ответственный за релиз ${AUTHOR}**\n\nКоммиты, попавшие в релиз:\n ${COMMITS}"

CREATE_TASK_URL="https://api.tracker.yandex.net/v2/issues/INFRA-46"

HEADER_OAUTH="Authorization: OAuth ${ACCESS_TOKEN}"
HEADER_ORG_ID="X-Org-ID: ${ORG_ID}"
HEADER_CONTENT_TYPE="Content-Type: application/json"
REQUEST='{
    "summary": "'"${SUMMARY}"'",
    "description": "'$DESCRIPTION'"
}'

CREATE_COMMENT_URL="https://api.tracker.yandex.net/v2/issues/INFRA-46/comments"
COMMENT_REQUEST_BODY='{
  "text":"Собрали образ c тегом '${RELEASE_VERSION}'"
}'

ADD_COMMENT_RESPONSE=$(
curl -o /dev/null -s -w "%{http_code}\n" -location -request POST ${CREATE_COMMENT_URL} \
  --header "${HEADER_OAUTH}" \
  --header "${HEADER_ORG_ID}" \
  --header "${HEADER_CONTENT_TYPE}" \
  --data "$COMMENT_REQUEST_BODY"
)
echo "Comment response: ${ADD_COMMENT_RESPONSE}."

CREATE_TASK_URL="https://api.tracker.yandex.net/v2/issues/INFRA-46"
RESPONSE=$(
  curl -so dev/null -w '%{http_code}' -X PATCH ${CREATE_TASK_URL} \
  --header "${HEADER_OAUTH}" \
  --header "${HEADER_ORG_ID}" \
  --header "${HEADER_CONTENT_TYPE}" \
  --data "$REQUEST"
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
