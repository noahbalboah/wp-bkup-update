# wp-bkup-update
A simple bash script. Automates backing up of WordPress file system and database. Uses [wp-cli](http://wp-cli.org/) to update WP core, plugins, themes of WP instance. Intended for use with root crontab

## Instructions:
1. ensure [wp-cli](http://wp-cli.org/) is installed on your web server
2. upload `wp-bkup-update.sh` to /root/ directory
3. change permissions to allow root to execute `wp-bkup-update.sh` (`chown root wp-bkup-update.sh; chmod 700 wp-bkup-update.sh`)
4. set up crontab

### crontab
##### Example crontab (for root), will run every Wednesday morning a 6:54am
54 6 * * 3 /root/wp-bkup-update.sh 

