#!/bin/sh

#set -x

echo "staring mes central"

export PORT  
export REDIRPORT
#export MPSPORT
export EMAIL
#export HOST
#export SMTP
#export USER
#export PASS
#export DB
#export MONGODB
#export MONGODBCOL

su - meshserver
cd /home/meshserver/
# npm install meshcentral

sed -i "s#: 443,#: $PORT,#" meshcentral-data/config.json
sed -i "s#: 80,#: $REDIRPORT,#" meshcentral-data/config.json

if [ -f "/etc/letsencrypt/archive/$HOSTNAME/cert1.pem" ]
then
    ln -sf "/etc/letsencrypt/archive/$HOSTNAME/privkey1.pem" meshcentral-data/agentserver-cert-private.key  
    ln -sf "/etc/letsencrypt/archive/$HOSTNAME/cert1.pem" meshcentral-data/agentserver-cert-public.crt
    ln -sf "/etc/letsencrypt/archive/$HOSTNAME/privkey1.pem" meshcentral-data/root-cert-private.key   
    ln -sf "/etc/letsencrypt/archive/$HOSTNAME/cert1.pem" meshcentral-data/root-cert-public.crt     
    ln -sf "/etc/letsencrypt/archive/$HOSTNAME/privkey1.pem" meshcentral-data/webserver-cert-private.key   
    ln -sf "/etc/letsencrypt/archive/$HOSTNAME/cert1.pem" meshcentral-data/webserver-cert-public.crt
    ln -sf "/etc/letsencrypt/archive/$HOSTNAME/privkey1.pem" meshcentral-data/mpsserver-cert-private.key 
    ln -sf "/etc/letsencrypt/archive/$HOSTNAME/cert1.pem" meshcentral-data/mpsserver-cert-public.crt
fi

# if ! [ -f meshcentral-data/agentserver-cert-private.key ]
# then 
# 	node node_modules/meshcentral/meshcentral.js --cert $HOSTNAME
# else 
# 	node node_modules/meshcentral/meshcentral.js
# fi
node node_modules/meshcentral/meshcentral.js

