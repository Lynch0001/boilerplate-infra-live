#!/bin/sh

#
# Shell script to create new DEMO Cluster project helm chart values files
# Copies, templatizes, and creates new project values file using boilerplate binary at BOILERPLATE_PATH
#
# execution command: ./build_infra.sh new_project
#

TARGET_PROJECT=$1
BOILERPLATE_PATH="/usr/local/bin"
DEMO_BASE_PATH="infra-live/prod/us-east-1/xib/xib-demo"
ARGOCD_DEMO_BASE_PATH="infra-live/prod/us-east-1/ir/downstream/argocd/xib/xib-demo"

# Verify build_infra_vars.yaml project input matches command line project input

sed -i 's/Project: .*/Project: '$TARGET_PROJECT'/g' ./build_infra_vars.yml

#
# create project folder
#
# if needed, create folders
# copy existing terragrunt file to template folder
# templatize terragrunt file
# create new project terragrunt file
# clean up terragrunt in template folder
#

#
# TODO
# Networking - Variable SFTP/MQ ports
# MQ - Variable segment hosts/ports/flags
# MQ Deployments require mq1 for certs unless modified
#

mkdir $DEMO_BASE_PATH/$TARGET_PROJECT

#
# Project
#
cp $DEMO_BASE_PATH/project/alpha/terragrunt.hcl $DEMO_BASE_PATH/project/alpha-template/terragrunt.hcl
sed -i 's/alpha/{{ .Project }}/g' $DEMO_BASE_PATH/project/alpha-template/terragrunt.hcl
$BOILERPLATE_PATH/boilerplate_linux_amd64 --var-file build_infra_vars.yml --template-url ./$DEMO_BASE_PATH/project/alpha-template --output-folder $DEMO_BASE_PATH/project/$TARGET_PROJECT --non-interactive
rm $DEMO_BASE_PATH/project/alpha-template/terragrunt.hcl

#
# Zookeeper
#
SERVICE="zookeeper"
cp $DEMO_BASE_PATH/alpha/$SERVICE/terragrunt.hcl $DEMO_BASE_PATH/alpha-template/$SERVICE/terragrunt.hcl
sed -i 's/alpha/{{ .Project }}/g' $DEMO_BASE_PATH/alpha-template/$SERVICE/terragrunt.hcl
$BOILERPLATE_PATH/boilerplate_linux_amd64 --var-file build_infra_vars.yml --template-url ./$DEMO_BASE_PATH/alpha-template/$SERVICE --output-folder $DEMO_BASE_PATH/$TARGET_PROJECT/$SERVICE --non-interactive
rm $DEMO_BASE_PATH/alpha-template/$SERVICE/terragrunt.hcl

#
# Kafka
#
SERVICE="kafka"
cp $DEMO_BASE_PATH/alpha/$SERVICE/terragrunt.hcl $DEMO_BASE_PATH/alpha-template/$SERVICE/terragrunt.hcl
sed -i 's/alpha/{{ .Project }}/g' $DEMO_BASE_PATH/alpha-template/$SERVICE/terragrunt.hcl
$BOILERPLATE_PATH/boilerplate_linux_amd64 --var-file build_infra_vars.yml --template-url ./$DEMO_BASE_PATH/alpha-template/$SERVICE --output-folder $DEMO_BASE_PATH/$TARGET_PROJECT/$SERVICE --non-interactive
rm $DEMO_BASE_PATH/alpha-template/$SERVICE/terragrunt.hcl

#
# Artemis
#
SERVICE="artemis-operator-broker"
cp $DEMO_BASE_PATH/alpha/$SERVICE/artemis-namespace/terragrunt.hcl $DEMO_BASE_PATH/alpha-template/$SERVICE/artemis-namespace/terragrunt.hcl
cp $DEMO_BASE_PATH/alpha/$SERVICE/artemis-acceptor-secret/terragrunt.hcl $DEMO_BASE_PATH/alpha-template/$SERVICE/artemis-acceptor-secret/terragrunt.hcl
cp $DEMO_BASE_PATH/alpha/$SERVICE/artemis-broker/terragrunt.hcl $DEMO_BASE_PATH/alpha-template/$SERVICE/artemis-broker/terragrunt.hcl
sed -i 's/alpha/{{ .Project }}/g' $DEMO_BASE_PATH/alpha-template/$SERVICE/artemis-namespace/terragrunt.hcl
sed -i 's/alpha/{{ .Project }}/g' $DEMO_BASE_PATH/alpha-template/$SERVICE/artemis-acceptor-secret/terragrunt.hcl
sed -i 's/alpha/{{ .Project }}/g' $DEMO_BASE_PATH/alpha-template/$SERVICE/artemis-broker/terragrunt.hcl
$BOILERPLATE_PATH/boilerplate_linux_amd64 --var-file build_infra_vars.yml --template-url ./$DEMO_BASE_PATH/alpha-template/$SERVICE/artemis-namespace --output-folder $DEMO_BASE_PATH/$TARGET_PROJECT/$SERVICE/artemis-namespace --non-interactive
$BOILERPLATE_PATH/boilerplate_linux_amd64 --var-file build_infra_vars.yml --template-url ./$DEMO_BASE_PATH/alpha-template/$SERVICE/artemis-acceptor-secret --output-folder $DEMO_BASE_PATH/$TARGET_PROJECT/$SERVICE/artemis-acceptor-secret --non-interactive
$BOILERPLATE_PATH/boilerplate_linux_amd64 --var-file build_infra_vars.yml --template-url ./$DEMO_BASE_PATH/alpha-template/$SERVICE/artemis-broker --output-folder $DEMO_BASE_PATH/$TARGET_PROJECT/$SERVICE/artemis-broker --non-interactive
rm $DEMO_BASE_PATH/alpha-template/$SERVICE/artemis-namespace/terragrunt.hcl
rm $DEMO_BASE_PATH/alpha-template/$SERVICE/artemis-acceptor-secret/terragrunt.hcl
rm $DEMO_BASE_PATH/alpha-template/$SERVICE/artemis-broker/terragrunt.hcl

#
# IBM MQ
#
SERVICE="ibmmq"
# Namespace
cp $DEMO_BASE_PATH/alpha/$SERVICE/namespace/terragrunt.hcl $DEMO_BASE_PATH/alpha-template/$SERVICE/namespace/terragrunt.hcl
sed -i 's/alpha/{{ .Project }}/g' $DEMO_BASE_PATH/alpha-template/$SERVICE/namespace/terragrunt.hcl
$BOILERPLATE_PATH/boilerplate_linux_amd64 --var-file build_infra_vars.yml --template-url ./$DEMO_BASE_PATH/alpha-template/$SERVICE/namespace --output-folder $DEMO_BASE_PATH/$TARGET_PROJECT/$SERVICE/namespace --non-interactive
rm $DEMO_BASE_PATH/alpha-template/$SERVICE/namespace/terragrunt.hcl

# Queue Managers
QUEUE_MANAGER="qm1"
cp $DEMO_BASE_PATH/alpha/$SERVICE/queue-managers/$QUEUE_MANAGER/terragrunt.hcl $DEMO_BASE_PATH/alpha-template/$SERVICE/queue-managers/$QUEUE_MANAGER/terragrunt.hcl
cp $DEMO_BASE_PATH/alpha/$SERVICE/queue-managers/$QUEUE_MANAGER/values/extra.yaml $DEMO_BASE_PATH/alpha-template/$SERVICE/queue-managers/$QUEUE_MANAGER/values/extra.yaml
sed -i 's/alpha/{{ .Project }}/g' $DEMO_BASE_PATH/alpha-template/$SERVICE/queue-managers/$QUEUE_MANAGER/terragrunt.hcl
#
# extra values editting
#
$BOILERPLATE_PATH/boilerplate_linux_amd64 --var-file build_infra_vars.yml --template-url ./$DEMO_BASE_PATH/alpha-template/$SERVICE/queue-managers/$QUEUE_MANAGER --output-folder $DEMO_BASE_PATH/$TARGET_PROJECT/$SERVICE/queue-managers/$QUEUE_MANAGER --non-interactive
$BOILERPLATE_PATH/boilerplate_linux_amd64 --var-file build_infra_vars.yml --template-url ./$DEMO_BASE_PATH/alpha-template/$SERVICE/queue-managers/$QUEUE_MANAGER/values --output-folder $DEMO_BASE_PATH/$TARGET_PROJECT/$SERVICE/queue-managers/$QUEUE_MANAGER/values --non-interactive
rm $DEMO_BASE_PATH/alpha-template/$SERVICE/queue-managers/$QUEUE_MANAGER/terragrunt.hcl
rm $DEMO_BASE_PATH/alpha-template/$SERVICE/queue-managers/$QUEUE_MANAGER/values/extra.yaml

#
# Networking
# TODO SFTP - MQ PORT Mappings
#
SERVICE="networking"
cp $DEMO_BASE_PATH/alpha/$SERVICE/terragrunt.hcl $DEMO_BASE_PATH/alpha-template/$SERVICE/terragrunt.hcl
sed -i 's/alpha/{{ .Project }}/g' $DEMO_BASE_PATH/alpha-template/$SERVICE/terragrunt.hcl
$BOILERPLATE_PATH/boilerplate_linux_amd64 --var-file build_infra_vars.yml --template-url ./$DEMO_BASE_PATH/alpha-template/$SERVICE --output-folder $DEMO_BASE_PATH/$TARGET_PROJECT/$SERVICE --non-interactive
rm $DEMO_BASE_PATH/alpha-template/$SERVICE/terragrunt.hcl

#
# Keda Secret
#
SERVICE="keda-artemis-secret"
cp $DEMO_BASE_PATH/alpha/$SERVICE/terragrunt.hcl $DEMO_BASE_PATH/alpha-template/$SERVICE/terragrunt.hcl
sed -i 's/alpha/{{ .Project }}/g' $DEMO_BASE_PATH/alpha-template/$SERVICE/terragrunt.hcl
$BOILERPLATE_PATH/boilerplate_linux_amd64 --var-file build_infra_vars.yml --template-url ./$DEMO_BASE_PATH/alpha-template/$SERVICE --output-folder $DEMO_BASE_PATH/$TARGET_PROJECT/$SERVICE --non-interactive
mkdir $DEMO_BASE_PATH/$TARGET_PROJECT/$SERVICE/secret
cp $DEMO_BASE_PATH/alpha/$SERVICE/secret/secrets.yaml $DEMO_BASE_PATH/$TARGET_PROJECT/$SERVICE/secret/secrets.yaml
rm $DEMO_BASE_PATH/alpha-template/$SERVICE/terragrunt.hcl

#
# Keycloak
#
# secrets directory
SERVICE_MAIN="keycloak"
mkdir $DEMO_BASE_PATH/$TARGET_PROJECT/$SERVICE

#
# Keycloak - Console
#
SERVICE_SUB="console"
cp $DEMO_BASE_PATH/alpha/$SERVICE_MAIN/$SERVICE_SUB/terragrunt.hcl $DEMO_BASE_PATH/alpha-template/$SERVICE_MAIN/$SERVICE_SUB/terragrunt.hcl
sed -i 's/alpha/{{ .Project }}/g' $DEMO_BASE_PATH/alpha-template/$SERVICE_MAIN/$SERVICE_SUB/terragrunt.hcl
$BOILERPLATE_PATH/boilerplate_linux_amd64 --var-file build_infra_vars.yml --template-url ./$DEMO_BASE_PATH/alpha-template/$SERVICE_MAIN/$SERVICE_SUB --output-folder $DEMO_BASE_PATH/$TARGET_PROJECT/$SERVICE_MAIN/$SERVICE_SUB --non-interactive
rm $DEMO_BASE_PATH/alpha-template/$SERVICE_MAIN/$SERVICE_SUB/terragrunt.hcl

#
# Keycloak - OTI
#
SERVICE_SUB="oti"
cp $DEMO_BASE_PATH/alpha/$SERVICE_MAIN/$SERVICE_SUB/terragrunt.hcl $DEMO_BASE_PATH/alpha-template/$SERVICE_MAIN/$SERVICE_SUB/terragrunt.hcl
sed -i 's/alpha/{{ .Project }}/g' $DEMO_BASE_PATH/alpha-template/$SERVICE_MAIN/$SERVICE_SUB/terragrunt.hcl
$BOILERPLATE_PATH/boilerplate_linux_amd64 --var-file build_infra_vars.yml --template-url ./$DEMO_BASE_PATH/alpha-template/$SERVICE_MAIN/$SERVICE_SUB --output-folder $DEMO_BASE_PATH/$TARGET_PROJECT/$SERVICE_MAIN/$SERVICE_SUB --non-interactive
rm $DEMO_BASE_PATH/alpha-template/$SERVICE_MAIN/$SERVICE_SUB/terragrunt.hcl

#
# Xib Secrets
#

# secrets directory
SERVICE_MAIN="xib-secrets"
mkdir $DEMO_BASE_PATH/$TARGET_PROJECT/$SERVICE

#
# s1
#
SERVICE_SUB="s1"
cp $DEMO_BASE_PATH/alpha/$SERVICE_MAIN/$SERVICE_SUB/terragrunt.hcl $DEMO_BASE_PATH/alpha-template/$SERVICE_MAIN/$SERVICE_SUB/terragrunt.hcl
sed -i 's/alpha/{{ .Project }}/g' $DEMO_BASE_PATH/alpha-template/$SERVICE_MAIN/$SERVICE_SUB/terragrunt.hcl
$BOILERPLATE_PATH/boilerplate_linux_amd64 --var-file build_infra_vars.yml --template-url ./$DEMO_BASE_PATH/alpha-template/$SERVICE_MAIN/$SERVICE_SUB --output-folder $DEMO_BASE_PATH/$TARGET_PROJECT/$SERVICE_MAIN/$SERVICE_SUB --non-interactive
rm $DEMO_BASE_PATH/alpha-template/$SERVICE_MAIN/$SERVICE_SUB/terragrunt.hcl

#
# s2
#
SERVICE_SUB="s2"
cp $DEMO_BASE_PATH/alpha/$SERVICE_MAIN/$SERVICE_SUB/terragrunt.hcl $DEMO_BASE_PATH/alpha-template/$SERVICE_MAIN/$SERVICE_SUB/terragrunt.hcl
sed -i 's/alpha/{{ .Project }}/g' $DEMO_BASE_PATH/alpha-template/$SERVICE_MAIN/$SERVICE_SUB/terragrunt.hcl
$BOILERPLATE_PATH/boilerplate_linux_amd64 --var-file build_infra_vars.yml --template-url ./$DEMO_BASE_PATH/alpha-template/$SERVICE_MAIN/$SERVICE_SUB --output-folder $DEMO_BASE_PATH/$TARGET_PROJECT/$SERVICE_MAIN/$SERVICE_SUB --non-interactive
rm $DEMO_BASE_PATH/alpha-template/$SERVICE_MAIN/$SERVICE_SUB/terragrunt.hcl

#
# s3
#
SERVICE_SUB="s3"
cp $DEMO_BASE_PATH/alpha/$SERVICE_MAIN/$SERVICE_SUB/terragrunt.hcl $DEMO_BASE_PATH/alpha-template/$SERVICE_MAIN/$SERVICE_SUB/terragrunt.hcl
sed -i 's/alpha/{{ .Project }}/g' $DEMO_BASE_PATH/alpha-template/$SERVICE_MAIN/$SERVICE_SUB/terragrunt.hcl
$BOILERPLATE_PATH/boilerplate_linux_amd64 --var-file build_infra_vars.yml --template-url ./$DEMO_BASE_PATH/alpha-template/$SERVICE_MAIN/$SERVICE_SUB --output-folder $DEMO_BASE_PATH/$TARGET_PROJECT/$SERVICE_MAIN/$SERVICE_SUB --non-interactive
rm $DEMO_BASE_PATH/alpha-template/$SERVICE_MAIN/$SERVICE_SUB/terragrunt.hcl

#
# s4
#
SERVICE_SUB="s4"
cp $DEMO_BASE_PATH/alpha/$SERVICE_MAIN/$SERVICE_SUB/terragrunt.hcl $DEMO_BASE_PATH/alpha-template/$SERVICE_MAIN/$SERVICE_SUB/terragrunt.hcl
sed -i 's/alpha/{{ .Project }}/g' $DEMO_BASE_PATH/alpha-template/$SERVICE_MAIN/$SERVICE_SUB/terragrunt.hcl
$BOILERPLATE_PATH/boilerplate_linux_amd64 --var-file build_infra_vars.yml --template-url ./$DEMO_BASE_PATH/alpha-template/$SERVICE_MAIN/$SERVICE_SUB --output-folder $DEMO_BASE_PATH/$TARGET_PROJECT/$SERVICE_MAIN/$SERVICE_SUB --non-interactive
rm $DEMO_BASE_PATH/alpha-template/$SERVICE_MAIN/$SERVICE_SUB/terragrunt.hcl

#
# ArgoCD Applications
#

#
# Archiver
#
SERVICE="archiver"
BASE_PATH=$ARGOCD_DEMO_BASE_PATH
cp $BASE_PATH/alpha/$SERVICE/terragrunt.hcl $BASE_PATH/alpha-template/$SERVICE/terragrunt.hcl
sed -i 's/alpha/{{ .Project }}/g' $BASE_PATH/alpha-template/$SERVICE/terragrunt.hcl
$BOILERPLATE_PATH/boilerplate_linux_amd64 --var-file build_vars.yml --template-url ./$BASE_PATH/alpha-template/$SERVICE --output-folder $BASE_PATH/$TARGET_PROJECT/$SERVICE --non-interactive
rm $BASE_PATH/alpha-template/$SERVICE/terragrunt.hcl

#
# Console
#
SERVICE="console"
BASE_PATH=$ARGOCD_DEMO_BASE_PATH
cp $BASE_PATH/alpha/$SERVICE/terragrunt.hcl $BASE_PATH/alpha-template/$SERVICE/terragrunt.hcl
sed -i 's/alpha/{{ .Project }}/g' $BASE_PATH/alpha-template/$SERVICE/terragrunt.hcl
$BOILERPLATE_PATH/boilerplate_linux_amd64 --var-file build_vars.yml --template-url ./$BASE_PATH/alpha-template/$SERVICE --output-folder $BASE_PATH/$TARGET_PROJECT/$SERVICE --non-interactive
rm $BASE_PATH/alpha-template/$SERVICE/terragrunt.hcl

#
# Datastore
#
SERVICE="datastore"
BASE_PATH=$ARGOCD_DEMO_BASE_PATH
cp $BASE_PATH/alpha/$SERVICE/terragrunt.hcl $BASE_PATH/alpha-template/$SERVICE/terragrunt.hcl
sed -i 's/alpha/{{ .Project }}/g' $BASE_PATH/alpha-template/$SERVICE/terragrunt.hcl
$BOILERPLATE_PATH/boilerplate_linux_amd64 --var-file build_vars.yml --template-url ./$BASE_PATH/alpha-template/$SERVICE --output-folder $BASE_PATH/$TARGET_PROJECT/$SERVICE --non-interactive
rm $BASE_PATH/alpha-template/$SERVICE/terragrunt.hcl

#
# Deliver
#
SERVICE="deliver"
BASE_PATH=$ARGOCD_DEMO_BASE_PATH
cp $BASE_PATH/alpha/$SERVICE/terragrunt.hcl $BASE_PATH/alpha-template/$SERVICE/terragrunt.hcl
sed -i 's/alpha/{{ .Project }}/g' $BASE_PATH/alpha-template/$SERVICE/terragrunt.hcl
$BOILERPLATE_PATH/boilerplate_linux_amd64 --var-file build_vars.yml --template-url ./$BASE_PATH/alpha-template/$SERVICE --output-folder $BASE_PATH/$TARGET_PROJECT/$SERVICE --non-interactive
rm $BASE_PATH/alpha-template/$SERVICE/terragrunt.hcl

#
# Inbound
#
SERVICE="inbound"
BASE_PATH=$ARGOCD_DEMO_BASE_PATH
cp $BASE_PATH/alpha/$SERVICE/terragrunt.hcl $BASE_PATH/alpha-template/$SERVICE/terragrunt.hcl
sed -i 's/alpha/{{ .Project }}/g' $BASE_PATH/alpha-template/$SERVICE/terragrunt.hcl
$BOILERPLATE_PATH/boilerplate_linux_amd64 --var-file build_vars.yml --template-url ./$BASE_PATH/alpha-template/$SERVICE --output-folder $BASE_PATH/$TARGET_PROJECT/$SERVICE --non-interactive
rm $BASE_PATH/alpha-template/$SERVICE/terragrunt.hcl

#
# Client
#
SERVICE="client"
BASE_PATH=$ARGOCD_DEMO_BASE_PATH
cp $BASE_PATH/alpha/$SERVICE/terragrunt.hcl $BASE_PATH/alpha-template/$SERVICE/terragrunt.hcl
sed -i 's/alpha/{{ .Project }}/g' $BASE_PATH/alpha-template/$SERVICE/terragrunt.hcl
$BOILERPLATE_PATH/boilerplate_linux_amd64 --var-file build_vars.yml --template-url ./$BASE_PATH/alpha-template/$SERVICE --output-folder $BASE_PATH/$TARGET_PROJECT/$SERVICE --non-interactive
rm $BASE_PATH/alpha-template/$SERVICE/terragrunt.hcl

#
# Ingester
#
SERVICE="ingester"
BASE_PATH=$ARGOCD_DEMO_BASE_PATH
cp $BASE_PATH/alpha/$SERVICE/terragrunt.hcl $BASE_PATH/alpha-template/$SERVICE/terragrunt.hcl
sed -i 's/alpha/{{ .Project }}/g' $BASE_PATH/alpha-template/$SERVICE/terragrunt.hcl
$BOILERPLATE_PATH/boilerplate_linux_amd64 --var-file build_vars.yml --template-url ./$BASE_PATH/alpha-template/$SERVICE --output-folder $BASE_PATH/$TARGET_PROJECT/$SERVICE --non-interactive
rm $BASE_PATH/alpha-template/$SERVICE/terragrunt.hcl

#
# parser
#
SERVICE="parser"
BASE_PATH=$ARGOCD_DEMO_BASE_PATH
cp $BASE_PATH/alpha/$SERVICE/terragrunt.hcl $BASE_PATH/alpha-template/$SERVICE/terragrunt.hcl
sed -i 's/alpha/{{ .Project }}/g' $BASE_PATH/alpha-template/$SERVICE/terragrunt.hcl
$BOILERPLATE_PATH/boilerplate_linux_amd64 --var-file build_vars.yml --template-url ./$BASE_PATH/alpha-template/$SERVICE --output-folder $BASE_PATH/$TARGET_PROJECT/$SERVICE --non-interactive
rm $BASE_PATH/alpha-template/$SERVICE/terragrunt.hcl

#
# preparser
#
SERVICE="preparser"
BASE_PATH=$ARGOCD_DEMO_BASE_PATH
cp $BASE_PATH/alpha/$SERVICE/terragrunt.hcl $BASE_PATH/alpha-template/$SERVICE/terragrunt.hcl
sed -i 's/alpha/{{ .Project }}/g' $BASE_PATH/alpha-template/$SERVICE/terragrunt.hcl
$BOILERPLATE_PATH/boilerplate_linux_amd64 --var-file build_vars.yml --template-url ./$BASE_PATH/alpha-template/$SERVICE --output-folder $BASE_PATH/$TARGET_PROJECT/$SERVICE --non-interactive
rm $BASE_PATH/alpha-template/$SERVICE/terragrunt.hcl
#
# resubmit
#
SERVICE="resubmit"
BASE_PATH=$ARGOCD_DEMO_BASE_PATH
cp $BASE_PATH/alpha/$SERVICE/terragrunt.hcl $BASE_PATH/alpha-template/$SERVICE/terragrunt.hcl
sed -i 's/alpha/{{ .Project }}/g' $BASE_PATH/alpha-template/$SERVICE/terragrunt.hcl
$BOILERPLATE_PATH/boilerplate_linux_amd64 --var-file build_vars.yml --template-url ./$BASE_PATH/alpha-template/$SERVICE --output-folder $BASE_PATH/$TARGET_PROJECT/$SERVICE --non-interactive
rm $BASE_PATH/alpha-template/$SERVICE/terragrunt.hcl

#
# router
#
SERVICE="router"
BASE_PATH=$ARGOCD_DEMO_BASE_PATH
cp $BASE_PATH/alpha/$SERVICE/terragrunt.hcl $BASE_PATH/alpha-template/$SERVICE/terragrunt.hcl
sed -i 's/alpha/{{ .Project }}/g' $BASE_PATH/alpha-template/$SERVICE/terragrunt.hcl
$BOILERPLATE_PATH/boilerplate_linux_amd64 --var-file build_vars.yml --template-url ./$BASE_PATH/alpha-template/$SERVICE --output-folder $BASE_PATH/$TARGET_PROJECT/$SERVICE --non-interactive
rm $BASE_PATH/alpha-template/$SERVICE/terragrunt.hcl

#
# twinning
#
SERVICE="twinning"
BASE_PATH=$ARGOCD_DEMO_BASE_PATH
cp $BASE_PATH/alpha/$SERVICE/terragrunt.hcl $BASE_PATH/alpha-template/$SERVICE/terragrunt.hcl
sed -i 's/alpha/{{ .Project }}/g' $BASE_PATH/alpha-template/$SERVICE/terragrunt.hcl
$BOILERPLATE_PATH/boilerplate_linux_amd64 --var-file build_vars.yml --template-url ./$BASE_PATH/alpha-template/$SERVICE --output-folder $BASE_PATH/$TARGET_PROJECT/$SERVICE --non-interactive
rm $BASE_PATH/alpha-template/$SERVICE/terragrunt.hcl

#
# OTI
#
SERVICE="oti"
BASE_PATH=$ARGOCD_DEMO_BASE_PATH
cp $BASE_PATH/alpha/$SERVICE/terragrunt.hcl $BASE_PATH/alpha-template/$SERVICE/terragrunt.hcl
sed -i 's/alpha/{{ .Project }}/g' $BASE_PATH/alpha-template/$SERVICE/terragrunt.hcl
$BOILERPLATE_PATH/boilerplate_linux_amd64 --var-file build_vars.yml --template-url ./$BASE_PATH/alpha-template/$SERVICE --output-folder $BASE_PATH/$TARGET_PROJECT/$SERVICE --non-interactive
rm $BASE_PATH/alpha-template/$SERVICE/terragrunt.hcl

#
# OTI-API
#
SERVICE="oti-api"
BASE_PATH=$ARGOCD_DEMO_BASE_PATH
cp $BASE_PATH/alpha/$SERVICE/terragrunt.hcl $BASE_PATH/alpha-template/$SERVICE/terragrunt.hcl
sed -i 's/alpha/{{ .Project }}/g' $BASE_PATH/alpha-template/$SERVICE/terragrunt.hcl
$BOILERPLATE_PATH/boilerplate_linux_amd64 --var-file build_vars.yml --template-url ./$BASE_PATH/alpha-template/$SERVICE --output-folder $BASE_PATH/$TARGET_PROJECT/$SERVICE --non-interactive
rm $BASE_PATH/alpha-template/$SERVICE/terragrunt.hcl

#
# Twingate
#
SERVICE="twingate"
BASE_PATH=$ARGOCD_DEMO_BASE_PATH
cp $BASE_PATH/alpha/$SERVICE/terragrunt.hcl $BASE_PATH/alpha-template/$SERVICE/terragrunt.hcl
sed -i 's/alpha/{{ .Project }}/g' $BASE_PATH/alpha-template/$SERVICE/terragrunt.hcl
$BOILERPLATE_PATH/boilerplate_linux_amd64 --var-file build_vars.yml --template-url ./$BASE_PATH/alpha-template/$SERVICE --output-folder $BASE_PATH/$TARGET_PROJECT/$SERVICE --non-interactive
rm $BASE_PATH/alpha-template/$SERVICE/terragrunt.hcl