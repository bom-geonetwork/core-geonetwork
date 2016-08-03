#!/bin/bash

# Delete the metadata records in to_host and
# upload the zip archive containing the mefs dumped using dumprecords.sh
#
# Note: Use port direct to tomcat (eg. 8080) as apache reverse proxies 
# drop the connection to the curl client after 900 seconds (5 minutes) with
# a 502 (this is important on the xml.mef.export service)
#

export TO_HOST=
export TO_CRED=
export TO_COOK=to_cookies
export INPUTFILE=


while getopts ":c:h:i:" opt; do
  case $opt in
    i)
      echo "MEFS will be loaded from file: $OPTARG" >&2
			INPUTFILE=$OPTARG
      ;;
    h)
      echo "Wiping and loading host: $OPTARG" >&2
			TO_HOST=${OPTARG}/srv/eng
      ;;
    c)
      echo "GeoNetwork credentials are: $OPTARG" >&2
			TO_CRED=$OPTARG
      ;;
    \?)
      echo "Invalid option: -$OPTARG" >&2
      exit 1
      ;;
    :)
      echo "Option -$OPTARG requires an argument." >&2
      exit 1
      ;;
  esac
done

if [ -z $TO_HOST ] || [ -z $TO_CRED ] || [ -z $INPUTFILE ]
then
  echo "Usage: $0 -h <geonetwork_host_url> -c <credentials> -i <inputfile>" >&2
	echo >&2
	echo "eg. $0 -h http://localhost:8080/geonetwork -c admin:admin -i exportfull.zip" >&2
	exit 1
fi

set -x

# Really important that any old cookies get deleted as can interfere with things
rm to_cookies

set +x
read -p "About to destroy records in GeoNetwork on $TO_HOST, OK? (y/n) " RESPONSE 
if [ "$RESPONSE" != "y" ]; then
	echo "Exiting"
	exit 1
fi

set -x
# Load them into TO_HOST GeoNetwork instance with uuidAction set to overwrite so that any existing records will be
# replaced with existing records

curl --cookie-jar $TO_COOK -w "%{http_code}" -H 'Accept:application/zip' -u $TO_CRED -F data="" -F file_type=mef -F insert_mode=1 -F assign=on -F mefFile=@$INPUTFILE -F uuidAction=overwrite -F template=n -F category=_none_ -F styleSheet=_none_ ${TO_HOST}/xml.mef.import

exit 0
