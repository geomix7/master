#!/bin/bash

# Space separated list of domains to check
DOMAINLIST="example.com
"

# Additional alert warning prepended if domain has less than this number of days before expiry
EXPIRYALERTDAYS=30
# Logfile/report location
LOGFILE=~/Desktop/tools/ssl_checker/SSL_report.md

# Clear last log
echo "" > $LOGFILE

for DOMAIN in $DOMAINLIST
do
	EXPIRY=$( echo | openssl s_client -servername $DOMAIN -connect $DOMAIN:443 2>/dev/null | openssl x509 -noout -dates | grep notAfter | sed 's/notAfter=//')
	ISSUER=$(curl https://$DOMAIN -vI --stderr - | grep "issuer" |awk '{print $8}')
	EXPIRYSIMPLE=$( date -d "$EXPIRY" +%F )
	EXPIRYSEC=$(date -d "$EXPIRY" +%s)
	TODAYSEC=$(date +%s)
	EXPIRYCALC=$(echo "($EXPIRYSEC-$TODAYSEC)/86400" | bc )
	# Output
	if [ $EXPIRYCALC -lt $EXPIRYALERTDAYS ] ;
	then
		echo "!!!Already Expired!!! $DOMAIN Cert needs to be renewed." >> $LOGFILE
	fi
	echo "$EXPIRYSIMPLE - $DOMAIN expires (in $EXPIRYCALC days issued by:$ISSUER)" >> $LOGFILE
done

# Report
sort -n -o $LOGFILE $LOGFILE
echo "SSL Expiration check finish!"
echo "View Report:" $LOGFILE
