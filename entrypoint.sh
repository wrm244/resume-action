#!/bin/sh

set -e

# setup ssh-private-key
mkdir -p /root/.ssh/
echo "$INPUT_DEPLOY_KEY" > /root/.ssh/id_rsa
chmod 600 /root/.ssh/id_rsa
ssh-keyscan -t rsa github.com >> /root/.ssh/known_hosts

# setup deploy git account
git config --global user.name "$INPUT_USER_NAME"
git config --global user.email "$INPUT_USER_EMAIL"

# install hexo env
npm install hexo-cli -g
npm install -g staticrypt
hexo g
hexo clean
# deployment
if [ "$INPUT_COMMIT_MSG" = "none" ]
then
    hexo g
    cd ./public
    staticrypt index.html -p 021212WhsWhs@@ -d ./
    staticrypt ./en/index.html -p 021212WhsWhs@@ -d ./en
    cd ..
    hexo deploy
elif [ "$INPUT_COMMIT_MSG" = "" ] || [ "$INPUT_COMMIT_MSG" = "default" ]
then
    # pull original publish repo
    NODE_PATH=$NODE_PATH:$(pwd)/node_modules node /sync_deploy_history.js
    hexo g
    cd ./public
    staticrypt index.html -p 021212WhsWhs@@ -d ./
    staticrypt ./en/index.html -p 021212WhsWhs@@ -d ./en
    cd ..
    hexo deploy
else
    NODE_PATH=$NODE_PATH:$(pwd)/node_modules node /sync_deploy_history.js
    hexo g
    cd ./public
    staticrypt index.html -p 021212WhsWhs@@ -d ./
    staticrypt ./en/index.html -p 021212WhsWhs@@ -d ./en
    cd ..
    hexo deploy -m "$INPUT_COMMIT_MSG"
fi

echo "Deploy complate."
