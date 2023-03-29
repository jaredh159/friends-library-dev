#!/bin/sh -l
SRC_FILE_PATH=$1
OBJECT_KEY=$2
ACCESS_KEY_ID=$3
ACCESS_KEY_SECRET=$4
BUCKET=$5
REGION=$6
ACL=$7
REMOVE_AFTER_UPLOAD=$8

mkdir -p ~/.aws

echo "[default]
aws_access_key_id = ${ACCESS_KEY_ID}
aws_secret_access_key = ${ACCESS_KEY_SECRET}" > ~/.aws/credentials

aws s3 cp ${SRC_FILE_PATH} s3://${BUCKET}/${OBJECT_KEY} \
  --acl ${ACL} \
  --region ${REGION} \
  --endpoint https://${REGION}.digitaloceanspaces.com

if [ "${REMOVE_AFTER_UPLOAD}" = "true" ]; then
  rm ${SRC_FILE_PATH}
fi
