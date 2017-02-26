#
# The .env file must contain
#    export JEKYLL_GITHUB_TOKEN=99...03
#

RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m' # No Color

source .env
echo "Jekyll activated:"
echo -e "   Run '${GREEN}vagrant up${NC}' to start the blog"
echo -e "   Run '${GREEN}vagrant ssh${NC}' to login into the virtual machine"
echo -e "   Run '${GREEN}vagrant halt${NC}' to stop the virtual machine"
echo -e "Now open http://local.mintusers.me "
echo -e "Full livereload support will provided.\n"
