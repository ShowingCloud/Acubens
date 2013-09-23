#!/bin/bash

set -x

git pull
rm -rf db/datadump
rake db:data:dump_dir dir="datadump"
git commit -a -m '`date`' -m '800ts modification'
git push
read -n1 -r -p 'Create pull request (if needed), approve it and press any key to continue' key

git pull
git fetch upstream
git merge upstream/master
rake db:migrate
rake db:seed
rake db:data:load_dir dir="datadump"
git push
