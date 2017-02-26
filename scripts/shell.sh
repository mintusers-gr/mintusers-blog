#!/bin/bash
echo "Ready to serve"
alias serve='jekyll serve --host 0.0.0.0 --force_polling'
cd /blog
echo "jekyll serve --watch 4000 --destination /var/www/html"
