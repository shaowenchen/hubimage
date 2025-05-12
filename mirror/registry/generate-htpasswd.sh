USERNAME=$1
PASSWORD=$2

nerdctl run \
  --entrypoint htpasswd \
  httpd:2 -Bbn $USERNAME $PASSWORD > auth/htpasswd