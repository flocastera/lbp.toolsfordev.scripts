#!/bin/bash

export WSP_PATH=$WSP_PATH
export SCRIPTS_PATH=$WSP_PATH/lbp.toolsfordev.scripts

export projectNamePatterns="(H[0-9]{2}\-)?[a-zA-Z]*$"
export watchPatterns="(module\-applicatif|composants\-applicatifs)"
export excludedProjectPathsPatterns="AccreditationService|pom\.xml|\.properties|SecurityBouchonConfig|\.classpath|\.settings|\.gitignore"