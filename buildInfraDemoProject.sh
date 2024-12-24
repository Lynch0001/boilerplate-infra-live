#!/bin/sh

#
# Shell script to create new DEMO Cluster project helm chart values files
# Copies, templatizes, and creates new project values file using boilerplate binary at BOILERPLATE_PATH
#
# execution command: ./build_infra.sh new_project
#
/bin/sh echo "started infra-live build"
export GIT_DISCOVERY_ACROSS_FILESYSTEM=1

TARGET_PROJECT=$1
BOILERPLATE_PATH="/Users/timothylynch/workspace/app"
BOILERPLATE_BINARY="boilerplate_darwin_amd64"
DEMO_BASE_PATH="prod/us-east-1/xib/xib-demo"
ARGOCD_DEMO_BASE_PATH="prod/us-east-1/ir/downstream/argocd/xib/xib-demo"
ROOT_PATH="/Users/timothylynch/workspace/app/boilerplate-infra-live"

# Verify build_infra_vars.yaml project input matches command line project input

sed -i '' 's/Project: .*/Project: '"$TARGET_PROJECT"'/g'  $ROOT_PATH/build_infra_vars.yml

mkdir $ROOT_PATH/$DEMO_BASE_PATH/$TARGET_PROJECT

#
# Project
#
cp $ROOT_PATH/$DEMO_BASE_PATH/project/alpha/terragrunt.hcl $ROOT_PATH/$DEMO_BASE_PATH/project/alpha-template/terragrunt.hcl
sed -i '' 's/alpha/{{ .Project }}/g' $ROOT_PATH/$DEMO_BASE_PATH/project/alpha-template/terragrunt.hcl
$BOILERPLATE_PATH/$BOILERPLATE_BINARY --var-file $ROOT_PATH/build_infra_vars.yml --template-url $ROOT_PATH/$DEMO_BASE_PATH/project/alpha-template --output-folder $ROOT_PATH/$DEMO_BASE_PATH/project/$TARGET_PROJECT --non-interactive
rm $ROOT_PATH/$DEMO_BASE_PATH/project/alpha-template/terragrunt.hcl

#
# Zookeeper
#
SERVICE="zookeeper"
cp $ROOT_PATH/$DEMO_BASE_PATH/alpha/$SERVICE/terragrunt.hcl $ROOT_PATH/$DEMO_BASE_PATH/alpha-template/$SERVICE/terragrunt.hcl
sed -i '' 's/alpha/{{ .Project }}/g' $ROOT_PATH/$DEMO_BASE_PATH/alpha-template/$SERVICE/terragrunt.hcl
$BOILERPLATE_PATH/$BOILERPLATE_BINARY --var-file $ROOT_PATH/build_infra_vars.yml --template-url $ROOT_PATH/$DEMO_BASE_PATH/alpha-template/$SERVICE --output-folder $ROOT_PATH/$DEMO_BASE_PATH/$TARGET_PROJECT/$SERVICE --non-interactive
rm $ROOT_PATH/$DEMO_BASE_PATH/alpha-template/$SERVICE/terragrunt.hcl

#
# Kafka
#
SERVICE="kafka"
cp $ROOT_PATH/$DEMO_BASE_PATH/alpha/$SERVICE/terragrunt.hcl $ROOT_PATH/$DEMO_BASE_PATH/alpha-template/$SERVICE/terragrunt.hcl
sed -i '' 's/alpha/{{ .Project }}/g' $ROOT_PATH/$DEMO_BASE_PATH/alpha-template/$SERVICE/terragrunt.hcl
$BOILERPLATE_PATH/$BOILERPLATE_BINARY --var-file $ROOT_PATH/build_infra_vars.yml --template-url $ROOT_PATH/$DEMO_BASE_PATH/alpha-template/$SERVICE --output-folder $ROOT_PATH/$DEMO_BASE_PATH/$TARGET_PROJECT/$SERVICE --non-interactive
rm $ROOT_PATH/$DEMO_BASE_PATH/alpha-template/$SERVICE/terragrunt.hcl

#
# Artemis
#
SERVICE="artemis-operator-broker"
cp $ROOT_PATH/$DEMO_BASE_PATH/alpha/$SERVICE/artemis-namespace/terragrunt.hcl $ROOT_PATH/$DEMO_BASE_PATH/alpha-template/$SERVICE/artemis-namespace/terragrunt.hcl
cp $ROOT_PATH/$DEMO_BASE_PATH/alpha/$SERVICE/artemis-acceptor-secret/terragrunt.hcl $ROOT_PATH/$DEMO_BASE_PATH/alpha-template/$SERVICE/artemis-acceptor-secret/terragrunt.hcl
cp $ROOT_PATH/$DEMO_BASE_PATH/alpha/$SERVICE/artemis-broker/terragrunt.hcl $ROOT_PATH/$DEMO_BASE_PATH/alpha-template/$SERVICE/artemis-broker/terragrunt.hcl
sed -i '' 's/alpha/{{ .Project }}/g' $ROOT_PATH/$DEMO_BASE_PATH/alpha-template/$SERVICE/artemis-namespace/terragrunt.hcl
sed -i '' 's/alpha/{{ .Project }}/g' $ROOT_PATH/$DEMO_BASE_PATH/alpha-template/$SERVICE/artemis-acceptor-secret/terragrunt.hcl
sed -i '' 's/alpha/{{ .Project }}/g' $ROOT_PATH/$DEMO_BASE_PATH/alpha-template/$SERVICE/artemis-broker/terragrunt.hcl
$BOILERPLATE_PATH/$BOILERPLATE_BINARY --var-file $ROOT_PATH/build_infra_vars.yml --template-url $ROOT_PATH/$DEMO_BASE_PATH/alpha-template/$SERVICE/artemis-namespace --output-folder $ROOT_PATH/$DEMO_BASE_PATH/$TARGET_PROJECT/$SERVICE/artemis-namespace --non-interactive
$BOILERPLATE_PATH/$BOILERPLATE_BINARY --var-file $ROOT_PATH/build_infra_vars.yml --template-url $ROOT_PATH/$DEMO_BASE_PATH/alpha-template/$SERVICE/artemis-acceptor-secret --output-folder $ROOT_PATH/$DEMO_BASE_PATH/$TARGET_PROJECT/$SERVICE/artemis-acceptor-secret --non-interactive
$BOILERPLATE_PATH/$BOILERPLATE_BINARY --var-file $ROOT_PATH/build_infra_vars.yml --template-url $ROOT_PATH/$DEMO_BASE_PATH/alpha-template/$SERVICE/artemis-broker --output-folder $ROOT_PATH/$DEMO_BASE_PATH/$TARGET_PROJECT/$SERVICE/artemis-broker --non-interactive
rm $ROOT_PATH/$DEMO_BASE_PATH/alpha-template/$SERVICE/artemis-namespace/terragrunt.hcl
rm $ROOT_PATH/$DEMO_BASE_PATH/alpha-template/$SERVICE/artemis-acceptor-secret/terragrunt.hcl
rm $ROOT_PATH/$DEMO_BASE_PATH/alpha-template/$SERVICE/artemis-broker/terragrunt.hcl

#
# IBM MQ
#
SERVICE="ibmmq"
# Namespace
cp $ROOT_PATH/$DEMO_BASE_PATH/alpha/$SERVICE/namespace/terragrunt.hcl $ROOT_PATH/$DEMO_BASE_PATH/alpha-template/$SERVICE/namespace/terragrunt.hcl
sed -i '' 's/alpha/{{ .Project }}/g' $ROOT_PATH/$DEMO_BASE_PATH/alpha-template/$SERVICE/namespace/terragrunt.hcl
$BOILERPLATE_PATH/$BOILERPLATE_BINARY --var-file $ROOT_PATH/build_infra_vars.yml --template-url $ROOT_PATH/$DEMO_BASE_PATH/alpha-template/$SERVICE/namespace --output-folder $ROOT_PATH/$DEMO_BASE_PATH/$TARGET_PROJECT/$SERVICE/namespace --non-interactive
rm $ROOT_PATH/$DEMO_BASE_PATH/alpha-template/$SERVICE/namespace/terragrunt.hcl

# Queue Managers
QUEUE_MANAGER="qm1"
cp $ROOT_PATH/$DEMO_BASE_PATH/alpha/$SERVICE/queue-managers/$QUEUE_MANAGER/terragrunt.hcl $ROOT_PATH/$DEMO_BASE_PATH/alpha-template/$SERVICE/queue-managers/$QUEUE_MANAGER/terragrunt.hcl
cp $ROOT_PATH/$DEMO_BASE_PATH/alpha/$SERVICE/queue-managers/$QUEUE_MANAGER/values/extra.yaml $ROOT_PATH/$DEMO_BASE_PATH/alpha-template/$SERVICE/queue-managers/$QUEUE_MANAGER/values/extra.yaml
sed -i '' 's/alpha/{{ .Project }}/g' $ROOT_PATH/$DEMO_BASE_PATH/alpha-template/$SERVICE/queue-managers/$QUEUE_MANAGER/terragrunt.hcl
#
# extra values editting
#
$BOILERPLATE_PATH/$BOILERPLATE_BINARY --var-file $ROOT_PATH/build_infra_vars.yml --template-url $ROOT_PATH/$DEMO_BASE_PATH/alpha-template/$SERVICE/queue-managers/$QUEUE_MANAGER --output-folder $ROOT_PATH/$DEMO_BASE_PATH/$TARGET_PROJECT/$SERVICE/queue-managers/$QUEUE_MANAGER --non-interactive
$BOILERPLATE_PATH/$BOILERPLATE_BINARY --var-file $ROOT_PATH/build_infra_vars.yml --template-url $ROOT_PATH/$DEMO_BASE_PATH/alpha-template/$SERVICE/queue-managers/$QUEUE_MANAGER/values --output-folder $ROOT_PATH/$DEMO_BASE_PATH/$TARGET_PROJECT/$SERVICE/queue-managers/$QUEUE_MANAGER/values --non-interactive
rm $ROOT_PATH/$DEMO_BASE_PATH/alpha-template/$SERVICE/queue-managers/$QUEUE_MANAGER/terragrunt.hcl
rm $ROOT_PATH/$DEMO_BASE_PATH/alpha-template/$SERVICE/queue-managers/$QUEUE_MANAGER/values/extra.yaml

#
# Networking
# TODO SFTP - MQ PORT Mappings
#
SERVICE="networking"
cp $ROOT_PATH/$DEMO_BASE_PATH/alpha/$SERVICE/terragrunt.hcl $ROOT_PATH/$DEMO_BASE_PATH/alpha-template/$SERVICE/terragrunt.hcl
sed -i '' 's/alpha/{{ .Project }}/g' $ROOT_PATH/$DEMO_BASE_PATH/alpha-template/$SERVICE/terragrunt.hcl
$BOILERPLATE_PATH/$BOILERPLATE_BINARY --var-file $ROOT_PATH/build_infra_vars.yml --template-url $ROOT_PATH/$DEMO_BASE_PATH/alpha-template/$SERVICE --output-folder $ROOT_PATH/$DEMO_BASE_PATH/$TARGET_PROJECT/$SERVICE --non-interactive
rm $ROOT_PATH/$DEMO_BASE_PATH/alpha-template/$SERVICE/terragrunt.hcl

#
# Keda Secret
#
SERVICE="keda-artemis-secret"
cp $ROOT_PATH/$DEMO_BASE_PATH/alpha/$SERVICE/terragrunt.hcl $ROOT_PATH/$DEMO_BASE_PATH/alpha-template/$SERVICE/terragrunt.hcl
sed -i '' 's/alpha/{{ .Project }}/g' $ROOT_PATH/$DEMO_BASE_PATH/alpha-template/$SERVICE/terragrunt.hcl
$BOILERPLATE_PATH/$BOILERPLATE_BINARY --var-file $ROOT_PATH/build_infra_vars.yml --template-url $ROOT_PATH/$DEMO_BASE_PATH/alpha-template/$SERVICE --output-folder $ROOT_PATH/$DEMO_BASE_PATH/$TARGET_PROJECT/$SERVICE --non-interactive
mkdir $ROOT_PATH/$DEMO_BASE_PATH/$TARGET_PROJECT/$SERVICE/secret
cp $ROOT_PATH/$DEMO_BASE_PATH/alpha/$SERVICE/secret/secrets.yaml $ROOT_PATH/$DEMO_BASE_PATH/$TARGET_PROJECT/$SERVICE/secret/secrets.yaml
rm $ROOT_PATH/$DEMO_BASE_PATH/alpha-template/$SERVICE/terragrunt.hcl

#
# Keycloak
#
# secrets directory
SERVICE_MAIN="keycloak"
mkdir $ROOT_PATH/$DEMO_BASE_PATH/$TARGET_PROJECT/$SERVICE

#
# Keycloak - Console
#
SERVICE_SUB="console"
cp $ROOT_PATH/$DEMO_BASE_PATH/alpha/$SERVICE_MAIN/$SERVICE_SUB/terragrunt.hcl $ROOT_PATH/$DEMO_BASE_PATH/alpha-template/$SERVICE_MAIN/$SERVICE_SUB/terragrunt.hcl
sed -i '' 's/alpha/{{ .Project }}/g' $ROOT_PATH/$DEMO_BASE_PATH/alpha-template/$SERVICE_MAIN/$SERVICE_SUB/terragrunt.hcl
$BOILERPLATE_PATH/$BOILERPLATE_BINARY --var-file $ROOT_PATH/build_infra_vars.yml --template-url $ROOT_PATH/$DEMO_BASE_PATH/alpha-template/$SERVICE_MAIN/$SERVICE_SUB --output-folder $ROOT_PATH/$DEMO_BASE_PATH/$TARGET_PROJECT/$SERVICE_MAIN/$SERVICE_SUB --non-interactive
rm $ROOT_PATH/$DEMO_BASE_PATH/alpha-template/$SERVICE_MAIN/$SERVICE_SUB/terragrunt.hcl

#
# Keycloak - OTI
#
SERVICE_SUB="oti"
cp $ROOT_PATH/$DEMO_BASE_PATH/alpha/$SERVICE_MAIN/$SERVICE_SUB/terragrunt.hcl $ROOT_PATH/$DEMO_BASE_PATH/alpha-template/$SERVICE_MAIN/$SERVICE_SUB/terragrunt.hcl
sed -i '' 's/alpha/{{ .Project }}/g' $ROOT_PATH/$DEMO_BASE_PATH/alpha-template/$SERVICE_MAIN/$SERVICE_SUB/terragrunt.hcl
$BOILERPLATE_PATH/$BOILERPLATE_BINARY --var-file $ROOT_PATH/build_infra_vars.yml --template-url $ROOT_PATH/$DEMO_BASE_PATH/alpha-template/$SERVICE_MAIN/$SERVICE_SUB --output-folder $ROOT_PATH/$DEMO_BASE_PATH/$TARGET_PROJECT/$SERVICE_MAIN/$SERVICE_SUB --non-interactive
rm $ROOT_PATH/$DEMO_BASE_PATH/alpha-template/$SERVICE_MAIN/$SERVICE_SUB/terragrunt.hcl

#
# Xib Secrets
#

# secrets directory
SERVICE_MAIN="xib-secrets"
mkdir $ROOT_PATH/$DEMO_BASE_PATH/$TARGET_PROJECT/$SERVICE

#
# s1
#
SERVICE_SUB="s1"
cp $ROOT_PATH/$DEMO_BASE_PATH/alpha/$SERVICE_MAIN/$SERVICE_SUB/terragrunt.hcl $ROOT_PATH/$DEMO_BASE_PATH/alpha-template/$SERVICE_MAIN/$SERVICE_SUB/terragrunt.hcl
sed -i '' 's/alpha/{{ .Project }}/g' $ROOT_PATH/$DEMO_BASE_PATH/alpha-template/$SERVICE_MAIN/$SERVICE_SUB/terragrunt.hcl
$BOILERPLATE_PATH/$BOILERPLATE_BINARY --var-file $ROOT_PATH/build_infra_vars.yml --template-url $ROOT_PATH/$DEMO_BASE_PATH/alpha-template/$SERVICE_MAIN/$SERVICE_SUB --output-folder $ROOT_PATH/$DEMO_BASE_PATH/$TARGET_PROJECT/$SERVICE_MAIN/$SERVICE_SUB --non-interactive
rm $ROOT_PATH/$DEMO_BASE_PATH/alpha-template/$SERVICE_MAIN/$SERVICE_SUB/terragrunt.hcl

#
# s2
#
SERVICE_SUB="s2"
cp $ROOT_PATH/$DEMO_BASE_PATH/alpha/$SERVICE_MAIN/$SERVICE_SUB/terragrunt.hcl $ROOT_PATH/$DEMO_BASE_PATH/alpha-template/$SERVICE_MAIN/$SERVICE_SUB/terragrunt.hcl
sed -i '' 's/alpha/{{ .Project }}/g' $ROOT_PATH/$DEMO_BASE_PATH/alpha-template/$SERVICE_MAIN/$SERVICE_SUB/terragrunt.hcl
$BOILERPLATE_PATH/$BOILERPLATE_BINARY --var-file $ROOT_PATH/build_infra_vars.yml --template-url $ROOT_PATH/$DEMO_BASE_PATH/alpha-template/$SERVICE_MAIN/$SERVICE_SUB --output-folder $ROOT_PATH/$DEMO_BASE_PATH/$TARGET_PROJECT/$SERVICE_MAIN/$SERVICE_SUB --non-interactive
rm $ROOT_PATH/$DEMO_BASE_PATH/alpha-template/$SERVICE_MAIN/$SERVICE_SUB/terragrunt.hcl

#
# s3
#
SERVICE_SUB="s3"
cp $ROOT_PATH/$DEMO_BASE_PATH/alpha/$SERVICE_MAIN/$SERVICE_SUB/terragrunt.hcl $ROOT_PATH/$DEMO_BASE_PATH/alpha-template/$SERVICE_MAIN/$SERVICE_SUB/terragrunt.hcl
sed -i '' 's/alpha/{{ .Project }}/g' $ROOT_PATH/$DEMO_BASE_PATH/alpha-template/$SERVICE_MAIN/$SERVICE_SUB/terragrunt.hcl
$BOILERPLATE_PATH/$BOILERPLATE_BINARY --var-file $ROOT_PATH/build_infra_vars.yml --template-url $ROOT_PATH/$DEMO_BASE_PATH/alpha-template/$SERVICE_MAIN/$SERVICE_SUB --output-folder $ROOT_PATH/$DEMO_BASE_PATH/$TARGET_PROJECT/$SERVICE_MAIN/$SERVICE_SUB --non-interactive
rm $ROOT_PATH/$DEMO_BASE_PATH/alpha-template/$SERVICE_MAIN/$SERVICE_SUB/terragrunt.hcl

#
# s4
#
SERVICE_SUB="s4"
cp $ROOT_PATH/$DEMO_BASE_PATH/alpha/$SERVICE_MAIN/$SERVICE_SUB/terragrunt.hcl $ROOT_PATH/$DEMO_BASE_PATH/alpha-template/$SERVICE_MAIN/$SERVICE_SUB/terragrunt.hcl
sed -i '' 's/alpha/{{ .Project }}/g' $ROOT_PATH/$DEMO_BASE_PATH/alpha-template/$SERVICE_MAIN/$SERVICE_SUB/terragrunt.hcl
$BOILERPLATE_PATH/$BOILERPLATE_BINARY --var-file $ROOT_PATH/build_infra_vars.yml --template-url $ROOT_PATH/$DEMO_BASE_PATH/alpha-template/$SERVICE_MAIN/$SERVICE_SUB --output-folder $ROOT_PATH/$DEMO_BASE_PATH/$TARGET_PROJECT/$SERVICE_MAIN/$SERVICE_SUB --non-interactive
rm $ROOT_PATH/$DEMO_BASE_PATH/alpha-template/$SERVICE_MAIN/$SERVICE_SUB/terragrunt.hcl

#
# ArgoCD Applications
#

#
# Archiver
#
SERVICE="archiver"
BASE_PATH=$ARGOCD_DEMO_BASE_PATH
cp $ROOT_PATH/$BASE_PATH/alpha/$SERVICE/terragrunt.hcl $ROOT_PATH/$BASE_PATH/alpha-template/$SERVICE/terragrunt.hcl
sed -i '' 's/alpha/{{ .Project }}/g' $ROOT_PATH/$BASE_PATH/alpha-template/$SERVICE/terragrunt.hcl
$BOILERPLATE_PATH/$BOILERPLATE_BINARY --var-file $ROOT_PATH/build_infra_vars.yml --template-url $ROOT_PATH/$BASE_PATH/alpha-template/$SERVICE --output-folder $ROOT_PATH/$BASE_PATH/$TARGET_PROJECT/$SERVICE --non-interactive
rm $ROOT_PATH/$BASE_PATH/alpha-template/$SERVICE/terragrunt.hcl

#
# Console
#
SERVICE="console"
BASE_PATH=$ARGOCD_DEMO_BASE_PATH
cp $ROOT_PATH/$BASE_PATH/alpha/$SERVICE/terragrunt.hcl $ROOT_PATH/$BASE_PATH/alpha-template/$SERVICE/terragrunt.hcl
sed -i '' 's/alpha/{{ .Project }}/g' $ROOT_PATH/$BASE_PATH/alpha-template/$SERVICE/terragrunt.hcl
$BOILERPLATE_PATH/$BOILERPLATE_BINARY --var-file $ROOT_PATH/build_infra_vars.yml --template-url $ROOT_PATH/$BASE_PATH/alpha-template/$SERVICE --output-folder $ROOT_PATH/$BASE_PATH/$TARGET_PROJECT/$SERVICE --non-interactive
rm $ROOT_PATH/$BASE_PATH/alpha-template/$SERVICE/terragrunt.hcl

#
# Datastore
#
SERVICE="datastore"
BASE_PATH=$ARGOCD_DEMO_BASE_PATH
cp $ROOT_PATH/$BASE_PATH/alpha/$SERVICE/terragrunt.hcl $ROOT_PATH/$BASE_PATH/alpha-template/$SERVICE/terragrunt.hcl
sed -i '' 's/alpha/{{ .Project }}/g' $ROOT_PATH/$BASE_PATH/alpha-template/$SERVICE/terragrunt.hcl
$BOILERPLATE_PATH/$BOILERPLATE_BINARY --var-file $ROOT_PATH/build_infra_vars.yml --template-url $ROOT_PATH/$BASE_PATH/alpha-template/$SERVICE --output-folder $ROOT_PATH/$BASE_PATH/$TARGET_PROJECT/$SERVICE --non-interactive
rm $ROOT_PATH/$BASE_PATH/alpha-template/$SERVICE/terragrunt.hcl

#
# Deliver
#
SERVICE="deliver"
BASE_PATH=$ARGOCD_DEMO_BASE_PATH
cp $ROOT_PATH/$BASE_PATH/alpha/$SERVICE/terragrunt.hcl $ROOT_PATH/$BASE_PATH/alpha-template/$SERVICE/terragrunt.hcl
sed -i '' 's/alpha/{{ .Project }}/g' $ROOT_PATH/$BASE_PATH/alpha-template/$SERVICE/terragrunt.hcl
$BOILERPLATE_PATH/$BOILERPLATE_BINARY --var-file $ROOT_PATH/build_infra_vars.yml --template-url $ROOT_PATH/$BASE_PATH/alpha-template/$SERVICE --output-folder $ROOT_PATH/$BASE_PATH/$TARGET_PROJECT/$SERVICE --non-interactive
rm $ROOT_PATH/$BASE_PATH/alpha-template/$SERVICE/terragrunt.hcl

#
# Inbound
#
SERVICE="inbound"
BASE_PATH=$ARGOCD_DEMO_BASE_PATH
cp $ROOT_PATH/$BASE_PATH/alpha/$SERVICE/terragrunt.hcl $ROOT_PATH/$BASE_PATH/alpha-template/$SERVICE/terragrunt.hcl
sed -i '' 's/alpha/{{ .Project }}/g' $ROOT_PATH/$BASE_PATH/alpha-template/$SERVICE/terragrunt.hcl
$BOILERPLATE_PATH/$BOILERPLATE_BINARY --var-file $ROOT_PATH/build_infra_vars.yml --template-url $ROOT_PATH/$BASE_PATH/alpha-template/$SERVICE --output-folder $ROOT_PATH/$BASE_PATH/$TARGET_PROJECT/$SERVICE --non-interactive
rm $ROOT_PATH/$BASE_PATH/alpha-template/$SERVICE/terragrunt.hcl

#
# Client
#
SERVICE="client"
BASE_PATH=$ARGOCD_DEMO_BASE_PATH
cp $ROOT_PATH/$BASE_PATH/alpha/$SERVICE/terragrunt.hcl $ROOT_PATH/$BASE_PATH/alpha-template/$SERVICE/terragrunt.hcl
sed -i '' 's/alpha/{{ .Project }}/g' $ROOT_PATH/$BASE_PATH/alpha-template/$SERVICE/terragrunt.hcl
$BOILERPLATE_PATH/$BOILERPLATE_BINARY --var-file $ROOT_PATH/build_infra_vars.yml --template-url $ROOT_PATH/$BASE_PATH/alpha-template/$SERVICE --output-folder $ROOT_PATH/$BASE_PATH/$TARGET_PROJECT/$SERVICE --non-interactive
rm $ROOT_PATH/$BASE_PATH/alpha-template/$SERVICE/terragrunt.hcl

#
# Ingester
#
SERVICE="ingester"
BASE_PATH=$ARGOCD_DEMO_BASE_PATH
cp $ROOT_PATH/$BASE_PATH/alpha/$SERVICE/terragrunt.hcl $ROOT_PATH/$BASE_PATH/alpha-template/$SERVICE/terragrunt.hcl
sed -i '' 's/alpha/{{ .Project }}/g' $ROOT_PATH/$BASE_PATH/alpha-template/$SERVICE/terragrunt.hcl
$BOILERPLATE_PATH/$BOILERPLATE_BINARY --var-file $ROOT_PATH/build_infra_vars.yml --template-url $ROOT_PATH/$BASE_PATH/alpha-template/$SERVICE --output-folder $ROOT_PATH/$BASE_PATH/$TARGET_PROJECT/$SERVICE --non-interactive
rm $ROOT_PATH/$BASE_PATH/alpha-template/$SERVICE/terragrunt.hcl

#
# parser
#
SERVICE="parser"
BASE_PATH=$ARGOCD_DEMO_BASE_PATH
cp $ROOT_PATH/$BASE_PATH/alpha/$SERVICE/terragrunt.hcl $ROOT_PATH/$BASE_PATH/alpha-template/$SERVICE/terragrunt.hcl
sed -i '' 's/alpha/{{ .Project }}/g' $ROOT_PATH/$BASE_PATH/alpha-template/$SERVICE/terragrunt.hcl
$BOILERPLATE_PATH/$BOILERPLATE_BINARY --var-file $ROOT_PATH/build_infra_vars.yml --template-url $ROOT_PATH/$BASE_PATH/alpha-template/$SERVICE --output-folder $ROOT_PATH/$BASE_PATH/$TARGET_PROJECT/$SERVICE --non-interactive
rm $ROOT_PATH/$BASE_PATH/alpha-template/$SERVICE/terragrunt.hcl

#
# preparser
#
SERVICE="preparser"
BASE_PATH=$ARGOCD_DEMO_BASE_PATH
cp $ROOT_PATH/$BASE_PATH/alpha/$SERVICE/terragrunt.hcl $ROOT_PATH/$BASE_PATH/alpha-template/$SERVICE/terragrunt.hcl
sed -i '' 's/alpha/{{ .Project }}/g' $ROOT_PATH/$BASE_PATH/alpha-template/$SERVICE/terragrunt.hcl
$BOILERPLATE_PATH/$BOILERPLATE_BINARY --var-file $ROOT_PATH/build_infra_vars.yml --template-url $ROOT_PATH/$BASE_PATH/alpha-template/$SERVICE --output-folder $ROOT_PATH/$BASE_PATH/$TARGET_PROJECT/$SERVICE --non-interactive
rm $ROOT_PATH/$BASE_PATH/alpha-template/$SERVICE/terragrunt.hcl
#
# resubmit
#
SERVICE="resubmit"
BASE_PATH=$ARGOCD_DEMO_BASE_PATH
cp $ROOT_PATH/$BASE_PATH/alpha/$SERVICE/terragrunt.hcl $ROOT_PATH/$BASE_PATH/alpha-template/$SERVICE/terragrunt.hcl
sed -i '' 's/alpha/{{ .Project }}/g' $ROOT_PATH/$BASE_PATH/alpha-template/$SERVICE/terragrunt.hcl
$BOILERPLATE_PATH/$BOILERPLATE_BINARY --var-file $ROOT_PATH/build_infra_vars.yml --template-url $ROOT_PATH/$BASE_PATH/alpha-template/$SERVICE --output-folder $ROOT_PATH/$BASE_PATH/$TARGET_PROJECT/$SERVICE --non-interactive
rm $ROOT_PATH/$BASE_PATH/alpha-template/$SERVICE/terragrunt.hcl

#
# router
#
SERVICE="router"
BASE_PATH=$ARGOCD_DEMO_BASE_PATH
cp $ROOT_PATH/$BASE_PATH/alpha/$SERVICE/terragrunt.hcl $ROOT_PATH/$BASE_PATH/alpha-template/$SERVICE/terragrunt.hcl
sed -i '' 's/alpha/{{ .Project }}/g' $ROOT_PATH/$BASE_PATH/alpha-template/$SERVICE/terragrunt.hcl
$BOILERPLATE_PATH/$BOILERPLATE_BINARY --var-file $ROOT_PATH/build_infra_vars.yml --template-url $ROOT_PATH/$BASE_PATH/alpha-template/$SERVICE --output-folder $ROOT_PATH/$BASE_PATH/$TARGET_PROJECT/$SERVICE --non-interactive
rm $ROOT_PATH/$BASE_PATH/alpha-template/$SERVICE/terragrunt.hcl

#
# twinning
#
SERVICE="twinning"
BASE_PATH=$ARGOCD_DEMO_BASE_PATH
cp $ROOT_PATH/$BASE_PATH/alpha/$SERVICE/terragrunt.hcl $ROOT_PATH/$BASE_PATH/alpha-template/$SERVICE/terragrunt.hcl
sed -i '' 's/alpha/{{ .Project }}/g' $ROOT_PATH/$BASE_PATH/alpha-template/$SERVICE/terragrunt.hcl
$BOILERPLATE_PATH/$BOILERPLATE_BINARY --var-file $ROOT_PATH/build_infra_vars.yml --template-url $ROOT_PATH/$BASE_PATH/alpha-template/$SERVICE --output-folder $ROOT_PATH/$BASE_PATH/$TARGET_PROJECT/$SERVICE --non-interactive
rm $ROOT_PATH/$BASE_PATH/alpha-template/$SERVICE/terragrunt.hcl

#
# OTI
#
SERVICE="oti"
BASE_PATH=$ARGOCD_DEMO_BASE_PATH
cp $ROOT_PATH/$BASE_PATH/alpha/$SERVICE/terragrunt.hcl $ROOT_PATH/$BASE_PATH/alpha-template/$SERVICE/terragrunt.hcl
sed -i '' 's/alpha/{{ .Project }}/g' $ROOT_PATH/$BASE_PATH/alpha-template/$SERVICE/terragrunt.hcl
$BOILERPLATE_PATH/$BOILERPLATE_BINARY --var-file $ROOT_PATH/build_infra_vars.yml --template-url $ROOT_PATH/$BASE_PATH/alpha-template/$SERVICE --output-folder $ROOT_PATH/$BASE_PATH/$TARGET_PROJECT/$SERVICE --non-interactive
rm $ROOT_PATH/$BASE_PATH/alpha-template/$SERVICE/terragrunt.hcl

#
# OTI-API
#
SERVICE="oti-api"
BASE_PATH=$ARGOCD_DEMO_BASE_PATH
cp $ROOT_PATH/$BASE_PATH/alpha/$SERVICE/terragrunt.hcl $ROOT_PATH/$BASE_PATH/alpha-template/$SERVICE/terragrunt.hcl
sed -i '' 's/alpha/{{ .Project }}/g' $ROOT_PATH/$BASE_PATH/alpha-template/$SERVICE/terragrunt.hcl
$BOILERPLATE_PATH/$BOILERPLATE_BINARY --var-file $ROOT_PATH/build_infra_vars.yml --template-url $ROOT_PATH/$BASE_PATH/alpha-template/$SERVICE --output-folder $ROOT_PATH/$BASE_PATH/$TARGET_PROJECT/$SERVICE --non-interactive
rm $ROOT_PATH/$BASE_PATH/alpha-template/$SERVICE/terragrunt.hcl

#
# Twingate
#
SERVICE="twingate"
BASE_PATH=$ARGOCD_DEMO_BASE_PATH
cp $ROOT_PATH/$BASE_PATH/alpha/$SERVICE/terragrunt.hcl $ROOT_PATH/$BASE_PATH/alpha-template/$SERVICE/terragrunt.hcl
sed -i '' 's/alpha/{{ .Project }}/g' $ROOT_PATH/$BASE_PATH/alpha-template/$SERVICE/terragrunt.hcl
$BOILERPLATE_PATH/$BOILERPLATE_BINARY --var-file $ROOT_PATH/build_infra_vars.yml --template-url $ROOT_PATH/$BASE_PATH/alpha-template/$SERVICE --output-folder $ROOT_PATH/$BASE_PATH/$TARGET_PROJECT/$SERVICE --non-interactive
rm $ROOT_PATH/$BASE_PATH/alpha-template/$SERVICE/terragrunt.hcl

sed -i '' 's/Project: .*/Project: placeholder/g' $ROOT_PATH/build_infra_vars.yml
