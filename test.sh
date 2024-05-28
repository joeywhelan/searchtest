#!/bin/bash

echo -e '\n*** Smallest to Largest Intersections  ***'
memtier_benchmark --hide-histogram \
--server=localhost \
--port=12000 \
--test-time=30 \
--threads=10 \
--clients=10 \
--run-count=1 \
--command="FT.SEARCH idx '@num:[1000 2000] @color:{grey} @quote:\"little more than kin\"' RETURN 1 quote LIMIT 0 10 DIALECT 4"

echo -e '\n*** Largest to Smallest Intersections ***'
memtier_benchmark --hide-histogram \
--server=localhost \
--port=12000 \
--test-time=30 \
--threads=10 \
--clients=10 \
--run-count=1 \
--command="FT.SEARCH idx '@quote:\"little more than kin\" @color:{grey} @num:[1000 2000]' RETURN 1 quote LIMIT 0 10 DIALECT 4"

echo -e '\n*** TAG First  ***'
memtier_benchmark --hide-histogram \
--server=localhost \
--port=12000 \
--test-time=30 \
--threads=10 \
--clients=10 \
--run-count=1 \
--command="FT.SEARCH idx '@color:{grey} @num:[1000 2000] @quote:\"little more than kin\"' RETURN 1 quote LIMIT 0 10 DIALECT 4"

echo -e '\n*** TAG Last  ***'
memtier_benchmark --hide-histogram \
--server=localhost \
--port=12000 \
--test-time=30 \
--threads=10 \
--clients=10 \
--run-count=1 \
--command="FT.SEARCH idx '@num:[1000 2000] @quote:\"little more than kin\" @color:{grey}' RETURN 1 quote LIMIT 0 10 DIALECT 4"