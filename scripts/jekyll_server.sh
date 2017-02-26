#!/usr/bin/env bash
cd /vagrant/blog

# Kill everything that use port 4000
fuser -k 4000/tcp
mkdir -p /vagrant/tmp/run/  /vagrant/tmp/log

# We use a plugin so no need for --force_polling
bundle exec jekyll serve  --watch \
    --destination /vagrant/_site \
    --livereload \
    --host 0.0.0.0 \
    --trace \
    --incremental

