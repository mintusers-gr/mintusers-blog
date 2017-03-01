#!/usr/bin/env bash
if [ ! -d /vagrant ]
then
  source "$(dirname "${BASH_SOURCE[0]}")/utils.bash"
  source "$(dirname "${BASH_SOURCE[0]}")/../.env"
  cd "$(dirname "${BASH_SOURCE[0]}")/../jekyll-blog"
  $(dirname "${BASH_SOURCE[0]}")/check_config.sh
else
  source /vagrant/bin/utils.bash
  source /vagrant/.env
  /vagrant/bin/check_config.sh
  cd /vagrant/jekyll-blog
fi

# Kill everything that use port 4000
fuser -k 4000/tcp

echo $JEKYLL_GITHUB_TOKEN
# We use a plugin so no need for --force_polling
LISTEN_GEM_DEBUGGING=1 bundle exec jekyll serve  --watch \
    --destination ../www \
    --livereload \
    --host 0.0.0.0
