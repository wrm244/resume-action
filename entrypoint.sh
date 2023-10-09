#!/bin/sh

set -e

# 设置SSH私钥
setup_ssh() {
    mkdir -p /root/.ssh/
    echo "$INPUT_DEPLOY_KEY" > /root/.ssh/id_rsa
    chmod 600 /root/.ssh/id_rsa
    ssh-keyscan -t rsa github.com >> /root/.ssh/known_hosts
}

# 设置部署Git帐户
setup_git() {
    git config --global user.name "$INPUT_USER_NAME"
    git config --global user.email "$INPUT_USER_EMAIL"
}

# 安装Hexo环境
install_hexo() {
    npm install hexo-cli -g
    npm install -g staticrypt
}

# 处理index.html
process_index_html() {
    staticrypt index.html -p "$INPUT_ST_PW" -d ./ --short
    old_text='<p class="staticrypt-title">Protected Page</p>'
    new_text='<p class="staticrypt-title">欢迎登陆河山的简历</p>'
    sed -i "s|$old_text|$new_text|g" ./index.html
    old_text='<p></p>'
    new_text='<p><p><code><tt>出于隐私保护的原因，</tt></code><code><tt>请<a href="mailto:wrm244@qq.com">邮箱联系</a>获取密钥。</tt></code></p><p><code><tt><a href="en/">English</a></tt></code></p></p>'
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
    old_text='Bad password!'
    new_text='密码错误，请重新尝试！'
    sed -i "s|$old_text|$new_text|g" ./index.html
    old_text='Protected Page'
    new_text='河山的简历保护页面'
    sed -i "s|$old_text|$new_text|g" ./index.html
}

# 处理en/index.html
process_en_index_html() {
    staticrypt ./en/index.html -p "$INPUT_ST_PW" -d ./en --short
    old_text='<p class="staticrypt-title">Protected Page</p>'
    new_text='<p class="staticrypt-title">Welcome to Heshan'\''s resume</p>'
    sed -i "s|$old_text|$new_text|g" ./en/index.html
    old_text='<p></p>'
    new_text='<p><p><code><tt>For privacy reasons, </tt></code><code><tt>please contact <a href="mailto:wrm244@qq.com">email</a> to obtain the key.</tt></code></p><p><code><tt><a href="..">中文</a></tt></code></p></p>'
    sed -i "s|$old_text|$new_text|g" ./en/index.html
    old_text='Protected Page'
    new_text='RiverMountain's Resume Protected Page'
    sed -i "s|$old_text|$new_text|g" ./en/index.html
}

# Hexo生成和部署
deploy_hexo() {
    hexo g
    cd ./public
    process_index_html
    process_en_index_html
    cd ..
    hexo deploy "$1"
}

# 主逻辑
setup_ssh
setup_git
install_hexo

if [ "$INPUT_COMMIT_MSG" = "none" ] || [ "$INPUT_COMMIT_MSG" = "" ] || [ "$INPUT_COMMIT_MSG" = "default" ]
then
    # 拉取原始发布仓库
    NODE_PATH=$NODE_PATH:$(pwd)/node_modules node /sync_deploy_history.js

    deploy_hexo
else
    # 拉取原始发布仓库
    NODE_PATH=$NODE_PATH:$(pwd)/node_modules node /sync_deploy_history.js

    deploy_hexo -m "$INPUT_COMMIT_MSG"
fi

echo "Deploy complete."
