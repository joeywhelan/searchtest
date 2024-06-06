#!/bin/bash

memtier_benchmark --hide-histogram \
--server=localhost \
--port=12000 \
--test-time=60 \
--threads=10 \
--clients=4 \
--run-count=1 \
--command="FT.SEARCH idx '@num:[1000 2000] @color:{grey} @quote:\"little more than kin\"' RETURN 1 quote LIMIT 0 10 DIALECT 4"