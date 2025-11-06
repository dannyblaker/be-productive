set -a
source .env
set +a

wget -r --accept pdf --no-clobber $DOMAIN