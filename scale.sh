#!/bin/bash

export SEARCH_VER=20813
export SEARCH_UID=`curl -s -k -u "redis@redis.com:redis" https://localhost:9443/v1/modules | jq '.[] | select(.module_name=="search" and .version=='$SEARCH_VER').uid' | head -n 1` 
curl -s -k -u "redis@redis.com:redis" https://localhost:9443/v1/bdbs/1/modules/config -H "Content-Type:application/json" -d '{
    "modules": [
        {
            "module_name": "search",
            "module_args": "MT_MODE MT_MODE_FULL WORKER_THREADS 6"
        }
    ]
}'

curl -o /dev/null -s -k -u "redis@redis.com:redis" https://localhost:9443/v1/bdbs/1/modules/upgrade -H "Content-Type:application/json" -d '{
    "modules": [
      {
        "module_name": "search",
        "module_args": "MT_MODE MT_MODE_FULL WORKER_THREADS 6",
        "current_module": '$SEARCH_UID',
        "new_module": '$SEARCH_UID'
      }
    ]
}'