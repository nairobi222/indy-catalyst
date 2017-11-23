#!/bin/bash

usage() { #Usage function
  cat <<-EOF
  Tool to load data from the APISpec/TestData folder into the app

  Usage: ./loadData.sh [ -h -x -e <DataLoadEnv> ]

  OPTIONS:
  ========
    -h prints the usage for the script
    -x run the script in debug mode to see what's happening
    -e <server> load data into the specified server (default: local, Options: local/dev/test/prod/<URL>)

  Update settings.sh and settings.local.sh files to set defaults

EOF
exit
}

# Set project and local environment variables
if [ -f settings.sh ]; then
  . settings.sh
fi

# Script-specific variables to be set

# In case you wanted to check what variables were passed
# echo "flags = $*"
while getopts e:gh FLAG; do
  case $FLAG in
    e ) LOAD_DATA_SERVER=$OPTARG ;;
    x ) export DEBUG="${YES}" ;;
    h ) USAGE ;;
    \? ) #unrecognized option - show help
      echo -e \\n"Invalid script option: -${OPTARG}"\\n
      USAGE
      ;;
  esac
done

# Shift the parameters in case there any more to be used
shift $((OPTIND-1))
# echo Remaining arguments: $@

if [ ! -z "${DEBUG}" ]; then
  set -x
fi

# Load Test Data
echo -e "Loading data into TheOrgBook Server: ${LOAD_DATA_SERVER}"
pushd ../APISpec/TestData >/dev/null
./load-all.sh ${LOAD_DATA_SERVER}
popd >/dev/null
