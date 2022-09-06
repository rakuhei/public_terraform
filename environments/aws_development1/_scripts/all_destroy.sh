#!/bin/bash
SCRIPT_DIR=$(cd $(dirname $0); pwd)
cd ../
RESOURCE_DIR=`pwd`

if [ $# != 1 ]; then
  echo "引数エラー: $*"
else
  echo "Check Args OK: $1"
fi

cd $SCRIPT_DIR && cd ../
while read RESOURCE || [ -n "${FILE}" ];
do
  cd $RESOURCE_DIR/$RESOURCE
  terraform init
  terraform destroy --var-file=_$1.tfvars -auto-approve
  rm -rf .terraform
done < ${SCRIPT_DIR}/destroy.lst
