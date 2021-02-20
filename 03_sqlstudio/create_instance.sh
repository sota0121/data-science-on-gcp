#!/bin/bash

# flights というインスタンスを作る
# tier インスタンスのマシンスペックを設定している
# activation-policy ALWAYS > 常時起動するように設定してる
gcloud sql instances create flights \
    --tier=db-n1-standard-1 --activation-policy=ALWAYS --zone=asia-northeast2-a --project ds-on-gcp2021

echo "Please go to the GCP console and change the root password of the instance"