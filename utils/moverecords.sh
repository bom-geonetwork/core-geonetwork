#!/bin/bash

# Export all metadata records from from_host instance as a zip archive
# containing mefs. Then clear out the metadata records in to_host and
# upload the zip archive containing the mefs from to_host.
#
export FROM_HOST=http://plaja-hf.hba.marine.csiro.au:8080/geonetwork/srv/eng
export FROM_CRED=admin:admin
export FROM_COOK=from_cookies

export TO_HOST=http://localhost:8080/geonetwork/srv/eng
export TO_CRED=admin:admin
export TO_COOK=to_cookies

set -x

# Extract all metadata as mef files from FROM_HOST GeoNetwork instance
curl -o /dev/null --cookie-jar $FROM_COOK -i -w "%{http_code}" -H 'Accept:application/xml' -u $FROM_CRED ${FROM_HOST}/xml.search?any=

curl --cookie $FROM_COOK -w "%{http_code}" -H 'Accept:application/xml' -u $FROM_CRED ${FROM_HOST}/xml.metadata.select?selected=add-all

curl --cookie $FROM_COOK -w "%{http_code}" -H 'Accept:application/zip' -u $FROM_CRED ${FROM_HOST}/xml.mef.export?format=full\&version=2 -o export_full.zip

set +x
read -p "About to destroy records in GeoNetwork on $TO_HOST, OK? (y/n) " RESPONSE 
if [ "$RESPONSE" != "y" ]; then
	echo "Exiting"
fi

set -x
# Load them into TO_HOST GeoNetwork instance after clearing it out first
curl -o /dev/null --cookie-jar $TO_COOK -i -w "%{http_code}" -H 'Accept:application/xml' -u $TO_CRED ${TO_HOST}/xml.search?any=

curl --cookie $TO_COOK -w "%{http_code}" -H 'Accept:application/xml' -u $TO_CRED ${TO_HOST}/xml.metadata.select?selected=add-all

curl --cookie $TO_COOK -w "%{http_code}" -H 'Accept:application/xml' -u $TO_CRED ${TO_HOST}/xml.metadata.batch.delete

curl --cookie $TO_COOK -w "%{http_code}" -H 'Accept:application/zip' -u $TO_CRED -F data="" -F file_type=mef -F insert_mode=1 -F assign=on -F mefFile=@export_full.zip -F uuidAction=nothing -F template=n -F category=_none_ -F styleSheet=_none_ ${TO_HOST}/xml.mef.import

exit 0
