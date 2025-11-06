set -a
source .env
set +a

wget -r --no-clobber --wait=10 --random-wait $DOMAIN