#!/bin/bash

: "${AWS_PROFILE:=newbie-root}"
: "${AWS_REGION:=ap-southeast-1}"
: "${BUCKET:=music-homelab}"

function create_s3_bucket() {
  aws s3 mb s3://"$BUCKET" \
    --region "$AWS_REGION" \
    --profile "$AWS_PROFILE"
}

function enable_bucket_versioning() {
  aws s3api put-bucket-versioning \
    --bucket "$BUCKET" \
    --versioning-configuration Status=Enabled \
    --profile "$AWS_PROFILE"
}

function enable_bucket_encryption() {
  aws s3api put-bucket-encryption \
    --bucket "$BUCKET" \
    --server-side-encryption-configuration '{
      "Rules": [{
         "ApplyServerSideEncryptionByDefault": {
          "SSEAlgorithm": "AES256"
        }
      }]
    }' \
    --profile "$AWS_PROFILE"
}

function prepare_bucket_store_state() {
  if aws s3api head-bucket --bucket "$BUCKET" 2>/dev/null; then
    echo "S3 bucket already exists: $BUCKET"
    return 0
  fi

  echo "Creating S3 bucket: $BUCKET."
  create_s3_bucket
  enable_bucket_versioning
  enable_bucket_encryption
  echo "Creating S3 bucket: $BUCKET successfully."
}

prepare_bucket_store_state