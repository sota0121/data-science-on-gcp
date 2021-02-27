#!/bin/bash

bash authorize_cloudshell.sh
MYSQLIP=$(gcloud sql instances describe flights | grep ipAddress | tr ' ' '\n' | tail -1)
# sqlファイル内の各変数を sed により（文字列置換で）設定している
cat contingency.sql | sed 's/DEP_DELAY_THRESH/20/g' | sed 's/ARR_DELAY_THRESH/15/g' | mysql --host=$MYSQLIP --user=root --password --verbose