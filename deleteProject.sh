#!/bin/sh

TARGET_PROJECT=$1
DEMO_BASE_PATH="prod/us-east-1/xib/xib-demo"
ARGOCD_DEMO_BASE_PATH="prod/us-east-1/ir/downstream/argocd/xib/xib-demo"
ROOT_PATH="."

if [ $TARGET_PROJECT == "alpha" ]; then
  echo "Cannot delete alpha project values; exiting now"
  exit 0
fi

echo "cleaning project $TARGET_PROJECT files"
echo "cleaning $ROOT_PATH/$DEMO_BASE_PATH/$TARGET_PROJECT/"
rm -v -rf $ROOT_PATH/$DEMO_BASE_PATH/$TARGET_PROJECT/
echo "cleaning $ROOT_PATH/$DEMO_BASE_PATH/project/$TARGET_PROJECT/"
rm -v -rf $ROOT_PATH/$DEMO_BASE_PATH/project/$TARGET_PROJECT/
echo "cleaning $ROOT_PATH/$ARGOCD_DEMO_BASE_PATH/$TARGET_PROJECT/"
rm -v -rf $ROOT_PATH/$ARGOCD_DEMO_BASE_PATH/$TARGET_PROJECT/
