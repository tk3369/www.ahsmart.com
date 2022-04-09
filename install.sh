#!/bin/sh
# Install new web site 

path=`pwd`

# generate new site content
julia --project=. -e 'using Franklin; serve(; clear = true, single = true, cleanup = true)'

# make a backup
echo "Backing up web site"
cd /var/www/html
tar cfz __archive/backup-`date +%Y%m%d-%H%M%S`.tgz *.xml *.html *.jl assets css pub layout libs tag

# remove same files
echo "Removing existing files"
rm -rf *.xml *.html *.jl assets css pub layout libs tag

# install new files
echo "Installing new files from $path"
cd $path
cp -r __site/* /var/www/html
