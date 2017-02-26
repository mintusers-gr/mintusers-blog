#!/usr/bin/env bash

GITHUB_REPONAME_BLOG="mintusers-gr/mintusers-gr.github.io"
GITHUB_REPONAME_JEKYLL="mintusers-gr/mintusers-blog"

RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m' # No Color

# Get last commit message
last_commit=$(git log -1 --pretty=%B)
commit_date=$(date +' at %m-%d-%Y')
commit_message="${last_commit}${commit_date}"

WORK_DIR=`mktemp -d  /tmp/jekyllblog.XXXXXXXXXX`
echo -e "${GREEN}Clonning repository into ${WORK_DIR}${NC}"

# deletes the temp directory
function cleanup {
  rm -rf "$WORK_DIR"
  echo "Deleted temp working directory $WORK_DIR"
}

trap cleanup EXIT


# Clone the repository
pushd ${WORK_DIR}
git clone "git@github.com:${GITHUB_REPONAME_BLOG}.git"

# Generate production site
echo -e "${GREEN}Generating production site ${WORK_DIR}${NC}"
popd
cd blog
bundle exec jekyll build \
    --source . \
    --destination ${WORK_DIR}/mintusers-gr.github.io/ \
    --quiet

echo -e "${GREEN}Generating commit ${NC}"
pushd "${WORK_DIR}/mintusers-gr.github.io"
git add .
git status

git commit -m "${commit_message}"

echo -e "${GREEN}Pushing to remote${NC}: ${GITHUB_REPONAME_BLOG}"
git push origin master

echo -e "${GREEN}Pushing to remote${NC}: ${GITHUB_REPONAME_JEKYLL}"
popd
git push origin master

