#!/bin/bash
export RIOT_THREADS=32
export NUM_DOCS=10000000

echo -e "\n***Launch Redis Enterprise docker containers"
docker compose up -d

echo -e "\n*** Wait for Redis Enterprise to come up ***"
curl -s -o /dev/null --retry 5 --retry-all-errors --retry-delay 3 -f -k -u "redis@redis.com:redis" https://localhost:9443/v1/bootstrap

echo -e "\n*** Build Cluster ***"
docker exec -it re1 /opt/redislabs/bin/rladmin cluster create name cluster.local username redis@redis.com password redis
docker exec -it re2 /opt/redislabs/bin/rladmin cluster join nodes 192.168.20.2 username redis@redis.com password redis
docker exec -it re3 /opt/redislabs/bin/rladmin cluster join nodes 192.168.20.2 username redis@redis.com password redis

echo -e "\n*** Build RE DB ***"
curl -s -o /dev/null -k -u "redis@redis.com:redis" https://localhost:9443/v1/bdbs -H "Content-Type:application/json" -d @redb.json
sleep 1

echo -e "\n*** Create Index ***"
redis-cli -p 12000 FT.CREATE idx ON JSON PREFIX 1 key: SCHEMA $.num AS num NUMERIC SORTABLE $.color AS color TAG SORTABLE UNF $.quote AS quote TEXT NOSTEM SORTABLE

echo -e "\n*** Load DB ***"
riot -h localhost -p 12000 faker-import --threads $RIOT_THREADS --count $NUM_DOCS \
id="index" \
num="number.randomNumber()" \
color="color.name()" \
quote="shakespeare.hamletQuote()" \
json.set \
--keyspace key \
--keys id