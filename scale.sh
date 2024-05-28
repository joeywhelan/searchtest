#!/bin/bash
export SEARCH_THREADS=6
export SEARCH_UID=`curl -s -k -u "redis@redis.com:redis" https://localhost:9443/v1/bdbs/1 | jq '.module_list[] | select(.module_name=="search").module_id'` 

curl -s -k -u "redis@redis.com:redis" https://localhost:9443/v1/bdbs/1/modules/config -H "Content-Type:application/json" -d '{
    "modules": [
        {
            "module_name": "search",
            "module_args": "MT_MODE MT_MODE_FULL WORKER_THREADS '$SEARCH_THREADS'"
        }
    ]
}'

curl -o /dev/null -s -k -u "redis@redis.com:redis" https://localhost:9443/v1/bdbs/1/modules/upgrade -H "Content-Type:application/json" -d '{
    "modules": [
      {
        "module_name": "search",
        "module_args": "MT_MODE MT_MODE_FULL WORKER_THREADS '$SEARCH_THREADS'",
        "current_module": '$SEARCH_UID',
        "new_module": '$SEARCH_UID'
      }
    ]
}'