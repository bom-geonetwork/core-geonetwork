#!/bin/bash
#
# Script to dump GeoNetwork database using pg_dump.
#
#
# Build list of tables to dump using pg_dump - note the list is valid for
# for GN 2.10.x will need modification for 3.x.x
#
# We use the custom (compressed) format. The dump should be loaded into
# a fresh database created by running GeoNetwork 2.10.x (once) on a new 
# postgres/postgis database. The pg_restore command is:
#
# pg_restore -c -d <dbname> -O -U <user> -h <host> -W -f <pg_dump_file>
#

export USER=
export DB=
export HOST=
export OUTPUTFILE=

while getopts ":o:U:d:h:" opt; do
  case $opt in
    o)
      echo "Dumping to output file: $OPTARG" >&2
			OUTPUTFILE=$OPTARG
      ;;
    h)
      echo "Database is on host: $OPTARG" >&2
			HOST=$OPTARG
      ;;
    U)
      echo "pg user name is: $OPTARG" >&2
			USER=$OPTARG
      ;;
    d)
      echo "postgres db name is: $OPTARG" >&2
			DB=$OPTARG
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

if [ -z $OUTPUTFILE ] || [ -z $HOST ] || [ -z $DB ] || [ -z $USER ]
then
  echo "Usage: $0 -o <outputfile> -h <host> -d <database> -U <username>" >&2
	echo >&2
	echo "eg. ./dumpdb.sh -o junk -h www4 -d geonetwork -U gis" >&2
	exit 1
fi

export TABLES=""

while read table
do
   TABLES="$TABLES -t $table"
done <<-LISTOFTABLES
address                     
categories                  
categoriesdes               
cswservercapabilitiesinfo   
customelementset            
email                       
files                       
group_category              
groups                      
groupsdes                   
harvesterdata               
harvestersettings           
harvesthistory              
inspireatomfeed             
inspireatomfeed_entrylist   
isolanguages                
isolanguagesdes             
languages                   
mapservers                  
metadata                    
metadatacateg               
metadatafiledownloads       
metadatafileuploads         
metadataidentifiertemplate  
metadatanotifications       
metadatanotifications_tmp   
metadatanotifiers           
metadatarating              
metadatastatus              
operationallowed            
operations                  
operationsdes               
params                      
params_temp                 
regions                     
regionsdes                  
relations                   
requests                    
schematron                  
schematroncriteria          
schematroncriteriagroup     
schematrondes               
serviceparameters           
services                    
settings                    
sources                     
sourcesdes                  
spatialindex                
statusvalues                
statusvaluesdes             
thesaurus                   
useraddress                 
usergroups                  
usergroups_tmp              
users                       
users_tmp                   
validation                  
LISTOFTABLES


echo "Will dump list of tables $TABLES from postgres database $DB with user $USER on $HOST to output file on $OUTPUTFILE"

echo pg_dump $TABLES --format custom -f $OUTPUTFILE -U $USER -W $DB -h $HOST
pg_dump $TABLES --format custom -f $OUTPUTFILE -U $USER -W $DB -h $HOST
exit 0
