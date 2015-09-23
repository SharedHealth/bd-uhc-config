
#!/bin/bash

BASE_DIR=`dirname $0`
ROOT_DIR=$BASE_DIR/..

mkdir -p $ROOT_DIR/target
rm -rf $ROOT_DIR/target/bd-uhc_config.zip

cd $ROOT_DIR && zip -r target/bd-uhc_config.zip openmrs/* migrations/* openelis/* openerp/*
