#!/usr/bin/env bash

#RELEASE_VERSION_MOCK="v_0.0.52"

AUTHOR=$(git show "${RELEASE_VERSION}" --pretty=format:"%an" --no-patch)
#AUTHOR=$(git log "${RELEASE_VERSION}" --pretty=format:"%an" --no-patch)
DATE=$(git show "${RELEASE_VERSION}" --date=format:'%Y-%m-%d' --pretty="format:%ad" --no-patch)

COMMITS="Bad request"

if git show-ref --tags "$(git describe --tags --abbrev=0 "${RELEASE_VERSION}^" --match="v_*")" --quiet; then
	echo "i am in if"
	TAGS_BEFORE_LAST=$(git describe --tags --abbrev=0 "${RELEASE_VERSION}^" --match="v_*")
	COMMITS="$(git log --pretty=format:"%H %an %s" "v_0.0.70"..."${RELEASE_VERSION}")"
else
  	echo "i am in else"
    	COMMITS=$(git log --pretty=format:"%H %an %s" "${RELEASE_VERSION}")
fi

echo ${COMMITS} > in.txt
cat in.txt | tr -s '\r\n' ' ' > out.txt
COMMITS=$(cat out.txt)

#COMMITS=$(git log --pretty=format:"%H %an %s%n" v_0.0.52...${RELEASE_VERSION})
echo "RELEASE_VERSION: ${RELEASE_VERSION}"
#echo "COMMITS: ${COMMITS}"

#COMMITS=$(git log --pretty=format:"%H %an %s%n" "v_0.0.40"..."v_0.0.41^")
#echo "$(git log --pretty=format:"%H %an %s%n" "rc-0.0.1")"

#COMMITS="Ответственный за релиз nikitКоммиты, попавшие в релиз: c8d704933d42effdd83ff02726fc6e50d676cda7 nikit test without perenos stroki75f818e3024a3804b19e9664f146cb579dd789dd nikit test without perenos strokif6fe6cdda5824df15cae050c44194a13d39beaa4 nikit test without perenos stroki78bc463bb76869164c3fcaa2aeb813e0261adb44 nikit test without perenos strokidc32bd9b5e73f2dab6da86d97988f0b3ee840cf6 nikit test without perenos stroki44f959bb96a334406ccf8511127093c2731cab6e nikit test fetch-depthc60f58efe1ee7e7f42b3d41579738e322b8f56b2 nikit test fetch-depth01817e47f014db094c47543bb6bddd3e634d9044 nikit test fetch-depth"
SUMMARY="Релиз  №${RELEASE_VERSION#*_} от ${DATE}"
DESCRIPTION="Ответственный за релиз ${AUTHOR}Коммиты, попавшие в релиз: ${COMMITS}"



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
