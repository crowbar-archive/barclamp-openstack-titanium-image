glance/cache/files/ami/ubuntu-12.04-server-cloudimg-amd64.tar.gz is missing in the Git repository due to Github file size limitation

Run the script setup.sh before installing Glance barclamp
Change setup.sh permissions to execute setup.sh first
It will download cloud image archive from ubuntu website

Images synchronization (file storage) accross all Glance nodes is  done with cron jobs.
Cron jobs are ran every 2 minutes 
Images synchronization  accross all nodes has a maximum delay of: 2 minutes + images upload duration 
