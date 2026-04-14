#!/bin/bash
cd

echo "dumping all arguments"
echo $@

if [ -n "$CONFIG_FILE" ]; then
  # Priority 1 : If config file is found use it
  echo "About to execute:turnilo --config /etc/config/turnilo/config.yml"
  echo "printing content of config file.."
  ls -alt /etc/config/turnilo
  cat /etc/config/turnilo/config.yml
  echo "done printing content of config file.."
  turnilo --config /etc/config/turnilo/config.yml
elif [ -n "$MYARGS" ]; then
  # Priority 2 : If user is calling with command line, honor it"
  echo "About to execute:turnilo $MYARGS"
  turnilo ${MYARGS}
elif [ -n "$DRUID_BROKER_URL" ]; then
  if [ -n "$DUMP_CONFIG" ]; then
    echo "Arguments provided: DRUID_BROKER_URL = $DRUID_BROKER_URL, DUMP_CONFIG = $DUMP_CONFIG"
    # User is supplying broker URL with DUMP_CONFIG
    echo "About to execute:turnilo --druid ${DRUID_BROKER_URL} --print-config --with-comments > /etc/config/export/new-config.yml "
    turnilo --druid ${DRUID_BROKER_URL}  --print-config --with-comments > /etc/config/export/new-config.yml 
  else
    echo "Arguments provided: DRUID_BROKER_URL = $DRUID_BROKER_URL"
    # User is supplying broker URL
    echo "About to execute:turnilo --druid ${DRUID_BROKER_URL} "
    turnilo --druid ${DRUID_BROKER_URL}
  fi
else
  # No arguments supplied; Making an assumption that Druid is running at the linked container druid_host and default port
  echo "About to execute:turnilo --druid http://druid_host:8082"
  turnilo --druid http://druid_host:8082
fi
