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
GRANT ALL PRIVILEGES ON DATABASE flp TO jared; # maybe run this as postgres user?
\password jared # then type in password twice

# my connection string was then (in .env) `DATABASE_URL=postgresql://<user>:<pass>@localhost/<dbname>`

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
```

# then install and run let's encrypt, letting it finish the config
sudo apt install -y certbot python3-certbot-nginx
# choose 2 for https redirect
sudo certbot --nginx -d api-graphql.friendslibrary.com
sudo systemctl reload nginx

# customize
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
