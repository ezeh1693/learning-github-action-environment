#!/bin/bash

#Create an associative array. Requires bash >=4.0
declare -A modifiedTemplates
## boolean to indicate that all templates should be deployed
deploy_all=0
templatesSearchPattern="templates/*/"


## Build dynamic Github actions dynamic strategy as a JSON
function buildJsonOutput(){
  templatesJson='';
  for i in "${modifiedTemplates[@]}"
  do
    ## Format single template as json
    templatesJson+=$(printf '"%s",' "$i")
  done
  jsonLength=${#templatesJson}

  ## Remove last comma(,) from formatted json
  templatesJson="${templatesJson:0:$jsonLength-1}"

  ## Build dynamic Github actions strategy format
  result=$(printf '[%s]' "$templatesJson")
  echo "::set-output name=matrix::$result"
  echo "$result"
}

function updateModifiedTemplates(){
  echo "${modifiedTemplates[@]}"
}
echo "Head ref"
echo "$GITHUB_HEAD_REF"

if [[ $1 == "staging" || $1 == "prod" ]]; then
  echo "This on staging build: "
  git checkout HEAD~1
fi

## Loop through file changes to determine template folders that  changed.
echo "Listing modified paths.."
git diff --name-only origin/main HEAD > paths.txt
while IFS= read -r path
do
  echo "$path"
  if [[ $path == templates/* ]]; then
     searchSubStr=${path#*$templatesSearchPattern}
     pathLength=${#path}
     subStringLength=${#searchSubStr}

     ## Length of "templates/" in the path
     templateStrLength=10;
     ## Length of the template e.g pc-health => 9
     templateLen=$((pathLength-subStringLength-templateStrLength-1))
     ## Get template as a substring of the entire path
     template="${path:$templateStrLength:$templateLen}"
     modifiedTemplates["$template"]=$template
  else
     echo "Some modified file(s) are not under the 'templates' folder."
     deploy_all=1
     #break
  fi
done < paths.txt

## If deploy all is set, deploy all templates
if [[ $deploy_all == 1 ]]; then
  ##TODO: get *all* templates dynamically
  modifiedTemplates=([andela_template]="andela_template" ["tolet_template"]="tolet_template" [insight_template]="insight_template")
fi

buildJsonOutput

