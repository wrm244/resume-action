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
    staticrypt index.html -p "$INPUT_ST_PW" -d ./ --short
    old_text='<p class="staticrypt-title">Protected Page</p>'
    new_text='<p class="staticrypt-title">欢迎登陆河山的简历</p>'
    sed -i "s|$old_text|$new_text|g" ./index.html
    old_text='<p></p>'
    new_text='<p><p><code><tt>出于隐私保护的原因，</tt></code><code><tt>请<a href="mailto:wrm244@qq.com">邮箱联系</a>获取密钥。</tt></code></p></p>'
    sed -i "s|$old_text|$new_text|g" ./index.html
    old_text='DECRYPT'
    new_text='解密简历'
    sed -i "s|$old_text|$new_text|g" ./index.html
    old_text='placeholder="Password"'
    new_text='placeholder="请输入密码"'
    sed -i "s|$old_text|$new_text|g" ./index.html
    old_text='Remember me'
    new_text='记住我'
    sed -i "s|$old_text|$new_text|g" ./index.html 
    staticrypt ./en/index.html -p "$INPUT_ST_PW" -d ./en --short
    old_text='<p class="staticrypt-title">Protected Page</p>'
    new_text='<p class="staticrypt-title">Welcome to Heshan's resume</p>'
    sed -i "s|$old_text|$new_text|g" ./en/index.html
    old_text='<p></p>'
    new_text='<p><p><code><tt>For privacy reasons, </tt></code><code><tt>please contact <a href="mailto:wrm244@qq.com">email</a> to obtain the key.</tt></code></p></p>'
    sed -i "s|$old_text|$new_text|g" ./en/index.html
    cd ..
    hexo deploy
elif [ "$INPUT_COMMIT_MSG" = "" ] || [ "$INPUT_COMMIT_MSG" = "default" ]
then
    # pull original publish repo
    NODE_PATH=$NODE_PATH:$(pwd)/node_modules node /sync_deploy_history.js
    hexo g
    cd ./public
    staticrypt index.html -p "$INPUT_ST_PW" -d ./ --short
    old_text='<p class="staticrypt-title">Protected Page</p>'
    new_text='<p class="staticrypt-title">欢迎登陆河山的简历</p>'
    sed -i "s|$old_text|$new_text|g" ./index.html
    old_text='<p></p>'
    new_text='<p><p><code><tt>出于隐私保护的原因，</tt></code><code><tt>请<a href="mailto:wrm244@qq.com">邮箱联系</a>获取密钥。</tt></code></p></p>'
    sed -i "s|$old_text|$new_text|g" ./index.html
    old_text='DECRYPT'
    new_text='解密简历'
    sed -i "s|$old_text|$new_text|g" ./index.html
    old_text='placeholder="Password"'
    new_text='placeholder="请输入密码"'
    sed -i "s|$old_text|$new_text|g" ./index.html
    old_text='Remember me'
    new_text='记住我'
    sed -i "s|$old_text|$new_text|g" ./index.html 
    staticrypt ./en/index.html -p "$INPUT_ST_PW" -d ./en --short
    old_text='<p class="staticrypt-title">Protected Page</p>'
    new_text='<p class="staticrypt-title">Welcome to Heshan's resume</p>'
    sed -i "s|$old_text|$new_text|g" ./en/index.html
    old_text='<p></p>'
    new_text='<p><p><code><tt>For privacy reasons, </tt></code><code><tt>please contact <a href="mailto:wrm244@qq.com">email</a> to obtain the key.</tt></code></p></p>'
    sed -i "s|$old_text|$new_text|g" ./en/index.html
    cd ..
    hexo deploy
else
    NODE_PATH=$NODE_PATH:$(pwd)/node_modules node /sync_deploy_history.js
    hexo g
    cd ./public
    staticrypt index.html -p "$INPUT_ST_PW" -d ./ --short
    old_text='<p class="staticrypt-title">Protected Page</p>'
    new_text='<p class="staticrypt-title">欢迎登陆河山的简历</p>'
    sed -i "s|$old_text|$new_text|g" ./index.html
    old_text='<p></p>'
    new_text='<p><p><code><tt>出于隐私保护的原因，</tt></code><code><tt>请<a href="mailto:wrm244@qq.com">邮箱联系</a>获取密钥。</tt></code></p></p>'
    sed -i "s|$old_text|$new_text|g" ./index.html
    old_text='DECRYPT'
    new_text='解密简历'
    sed -i "s|$old_text|$new_text|g" ./index.html
    old_text='placeholder="Password"'
    new_text='placeholder="请输入密码"'
    sed -i "s|$old_text|$new_text|g" ./index.html
    old_text='Remember me'
    new_text='记住我'
    sed -i "s|$old_text|$new_text|g" ./index.html
    staticrypt ./en/index.html -p "$INPUT_ST_PW" -d ./en --short
    old_text='<p class="staticrypt-title">Protected Page</p>'
    new_text='<p class="staticrypt-title">Welcome to Heshan's resume</p>'
    sed -i "s|$old_text|$new_text|g" ./en/index.html
    old_text='<p></p>'
    new_text='<p><p><code><tt>For privacy reasons, </tt></code><code><tt>please contact <a href="mailto:wrm244@qq.com">email</a> to obtain the key.</tt></code></p></p>'
    sed -i "s|$old_text|$new_text|g" ./en/index.html
    cd ..
    hexo deploy -m "$INPUT_COMMIT_MSG"
fi

echo "Deploy complate."
