#!/bin/bash

echo -e '\n*** TAG-First Search ***'
memtier_benchmark --hide-histogram \
--server=localhost \
--port=12000 \
--test-time=30 \
--threads=10 \
--clients=10 \
--run-count=1 \
--command="FT.SEARCH idx '@color:{grey} @num:[1000 2000] @quote:\"little more than kin\"' RETURN 1 quote LIMIT 0 10 DIALECT 4"

echo -e '\n*** TAG-Last Search ***'
memtier_benchmark --hide-histogram \
--server=localhost \
--port=12000 \
--test-time=30 \
--threads=10 \
--clients=10 \
--run-count=1 \
--command="FT.SEARCH idx '@num:[1000 2000] @quote:\"little more than kin\" @color:{grey}' RETURN 1 quote LIMIT 0 10 DIALECT 4"