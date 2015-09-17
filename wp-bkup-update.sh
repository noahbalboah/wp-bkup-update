#!/bin/bash
# automates backing up of wordpress directory,
# automates backing up of wordpress database,
# automates updating core, plugins, themes of wordpress instance,
# emails the output
# intended to work with	root cron job, and wp-cli
# 
# Example crontab (for root), will run every Wednesday morning a 6:54am
# 54 6 * * 3 /root/wp-bkup-update.sh 
#
# @date July 2015
# @author Brad Payne

# send all output to a log file
logfile=/root/wp-bkup-update.log
exec > $logfile 2>&1

# set variables
WEB_ROOT="/var/www"
WP_DIR="html"
DATE=`date +%Y`
DB_USER="db_user"
DB_PWD="password"
DB_HOST="localhost"
DB="wordpress"
EMAILED_TO="someone@mydomain.com"

# back up file directory to a non-web location 
cd "$WEB_ROOT"
tar -czf /usr/local/"$WP_DIR"-"$DATE"-latest.tgz "$WP_DIR"
echo 'tar exit status = ' $?
 
# back up database to a non-web directory
cd /usr/local/
mysqldump -h "$DB_HOST" -P 3306 -u "$DB_USER" -p"$DB_PWD" "$DB" > "$DB"-"$DATE"-latest.sql
echo 'mysqldump exit status =' $?

# update plugins using wp-cli
# using su -s (run shell) instead of sudo is necessary to avoid 'sorry you must have tty to run sudo' error
# assumes the requiretty in /etc/sudoers is set to `Defaults requiretty`
cd "$WEB_ROOT"/"$WP_DIR"

# GNU+LINUX (Tested on RHEL6)
su -s /bin/bash apache -c "/usr/bin/wp core update"
su -s /bin/bash apache -c "/usr/bin/wp core update-db"
su -s /bin/bash apache -c "/usr/bin/wp plugin update --all"
su -s /bin/bash apache -c "/usr/bin/wp theme update --all"

# MAC OS (Tested on Yosemite) 
# sudo -u _www /usr/local/bin/wp core update
# sudo -u _www /usr/local/bin/wp core update-db
# sudo -u _www /usr/local/bin/wp plugin update --all
# sudo -u _www /usr/local/bin/wp theme update --all

#email the output
/bin/mail -s "wp backup and update" $EMAILED_TO < /root/wp-bkup-update.log