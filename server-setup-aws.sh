# figured out how to gzip inside of swift, so no longer using this, but just in case,
# here's how I set up cron-backed aws postgres backups:

# install aws cli @see https://docs.aws.amazon.com/cli/latest/userguide/install-cliv2-linux.html
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install
rm -rf ./aws
rm awscliv2.zip
# check with `aws --version`
# then configure with: (leave last two questions [None])
aws configure

# vim this script into ~/backup-db.sh
```
/usr/bin/pg_dump --inserts flp | /usr/bin/gzip -c > /home/jared/$(date -u +'%FT%H%MZ').sql.gz
/usr/local/bin/aws s3 cp /home/jared/*.sql.gz s3://flp-assets/storage/db-backups/ --endpoint=https://nyc3.digitaloceanspaces.com --quiet
/usr/bin/rm /home/jared/*.sql.gz
```

# then
crontab -e
# add line `0 4 * * * /usr/bin/bash /home/jared/backup-db.sh` to start backups
