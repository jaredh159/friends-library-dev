# entered password from buttercup, left everything else empty
adduser jared

# grant sudo privs
usermod -aG sudo jared

ufw allow OpenSSH
ufw enable

su jared
mkdir -p ~/.ssh
# copy over authorized keys
rsync --archive --chown=jared:jared ~/.ssh /home/jared
# back to root
exit
# don't ask `jared` for sudo password
echo "jared ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

# other programs
sudo apt install -y unzip
sudo apt install -y tree
sudo apt install -y ripgrep

# install postgresql
sudo apt update
sudo apt install -y postgresql postgresql-contrib

# switch to created postgres user
sudo -i -u postgres
createuser jared

# open psql shell for a hot second and then
psql
> ALTER USER jared WITH SUPERUSER;
> \q;
exit;# get back to being jared
# ... in order to create the database as jared
createdb flp

# then, INSIDE of the psql terminal i had to:
psql -d flp
> GRANT ALL PRIVILEGES ON DATABASE flp TO jared;
> \password jared # then type in password twice

# my connection string was then (in .env) `DATABASE_URL=postgresql://<user>:<pass>@localhost/<dbname>`

# create `staging` database
createdb staging
psql -d staging
> GRANT ALL PRIVILEGES ON DATABASE staging TO jared;

# create `staging_test` database
createdb staging_test
psql -d staging_test
> GRANT ALL PRIVILEGES ON DATABASE staging_test TO jared;

# generate an ssh key to access github
su jared
ssh-keygen -t rsa -C "jared@netrivet.com"
# add pub key to github, test with `ssh -T git@github.com`

# node things
curl -fsSL https://deb.nodesource.com/setup_14.x | sudo -E bash -
sudo apt-get install -y nodejs
# update npm
sudo npm install -g npm
# install pm2
sudo npm install -g pm2

# nginx
sudo apt install -y nginx
sudo ufw allow 'Nginx Full'
sudo ufw allow OpenSSH
sudo ufw enable

# make /etc/nginx/sites-available/default look approximately like this:
```
server {
  server_name api-graphql.friendslibrary.com;
  location / {
      proxy_pass http://127.0.0.1:8080;
      proxy_http_version 1.1;
      proxy_set_header Upgrade $http_upgrade;
      proxy_set_header Connection 'upgrade';
      proxy_set_header Host $host;
      proxy_set_header X-Real-IP $remote_addr;
      proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
      proxy_pass_header Server;
      proxy_cache_bypass $http_upgrade;
      proxy_connect_timeout 3s;
      proxy_read_timeout 10s;
   }
}

server {
  server_name api-graphql--staging.friendslibrary.com;
  location / {
      proxy_pass http://127.0.0.1:8090;
      proxy_http_version 1.1;
      proxy_set_header Upgrade $http_upgrade;
      proxy_set_header Connection 'upgrade';
      proxy_set_header Host $host;
      proxy_set_header X-Real-IP $remote_addr;
      proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
      proxy_pass_header Server;
      proxy_cache_bypass $http_upgrade;
      proxy_connect_timeout 3s;
      proxy_read_timeout 10s;
   }
}
```

# then install and run let's encrypt, letting it finish the config
sudo apt install -y certbot python3-certbot-nginx
# choose 2 for https redirect
sudo certbot --nginx -d api-graphql.friendslibrary.com
sudo certbot --nginx -d api-graphql--staging.friendslibrary.com
sudo systemctl reload nginx

# install swift
# get correct link from  https://swift.org/download/#releases
wget https://swift.org/builds/swift-5.4.2-release/ubuntu2004/swift-5.4.2-RELEASE/swift-5.4.2-RELEASE-ubuntu20.04.tar.gz
tar xzf swift-5.4.2-RELEASE-ubuntu20.04.tar.gz
sudo mkdir /swift
sudo mv swift-5.4.2-RELEASE-ubuntu20.04 /swift/5.4.2
sudo ln -s /swift/5.4.2/usr/bin/swift /usr/bin/swift
# check install
swift --version
rm swift-5.4.2-RELEASE-ubuntu20.04.tar.gz
# install swift deps: (from swift.org/downloads)
sudo apt-get install -y binutils git gnupg2 libc6-dev libcurl4 libedit2 libgcc-9-dev libpython2.7 libsqlite3-0 libstdc++-9-dev libxml2 libz3-dev pkg-config tzdata zlib1g-dev


# install vapor deps 
sudo apt-get install -y make openssl libssl-dev libsqlite3-dev
# install vapor (Optional, i had trouble with `make install`)
cd ~
git clone https://github.com/vapor/toolbox.git vapor-toolbox
cd vapor-toolbox
make install

# install `xcbeautify` for running tests
cd ~
git clone https://github.com/thii/xcbeautify.git
cd xcbeautify
make install
sudo mv /home/jared/xcbeautify/.build/x86_64-unknown-linux-gnu/release/xcbeautify /usr/local/bin/
rm -rf ~/xcbeautify

# if you want cron-based postgres backups uploaded to S3, see ./server-setup-aws.sh

# set timezone to EST for scheduled jobs, etc.
sudo timedatectl set-timezone America/New_York

# customize
echo "alias grep=rg" >> ~/.bashrc
echo "alias run='npm run \"\$@\"'" >> ~/.bashrc

vim ~/.gitconfig
# then add below:
```
[user]
    name = Jared Henderson
    email = jared@netrivet.com
[core]
    editor = vim
[alias]
    lg = log --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit
    resetone = reset HEAD~1
    co = checkout
    save = !git add -A && git commit -m 'SAVEPOINT'
    st = stash
    s = status
    br = branch
    l = log --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit -n 5
```
