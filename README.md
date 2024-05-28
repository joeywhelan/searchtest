# Redis Search - Query Term Order + Vertical Scaling Test

## Contents
1.  [Summary](#summary)
2.  [Approach](#approach)
3.  [Features](#features)
4.  [Prerequisites](#prerequisites)
5.  [Usage](#usage)
6.  [Results](#results)


## Summary <a name="summary"></a>
This is a series of shell scripts for testing query speeds against varied queries and search threading.  This is not intended to be a performance benchmark.  This is test that can be run on a laptop to gain intuition on the effects of query term order and vertical scaling with Redis Search.

## Approach <a name="approach"></a>
RE cluster is built, loaded with 10M JSON documents and tested.

## Features <a name="features"></a>
- 3-node Redis Enterprise cluster
- 2-shard RE DB w/Redis JSON + Search
- Riot script for loading 10M JSON documents
- Test script for memtier search queries for TAG at front of query and rear.
- Scale script to enable Redis Search Vertical Scaling (6 threads)

## Prerequisites <a name="prerequisites"></a>
- [Docker Compose](https://docs.docker.com/compose/)
- [Riot](https://github.com/redis/riot)
- [memtier_benchmark](https://github.com/RedisLabs/memtier_benchmark)
- [jq](https://jqlang.github.io/jq/)

## Usage <a name="usage"></a>
### Build RE Cluster + Load DB
```bash
./start.sh
```
### Test
```bash
./test.sh
```
### Dynamically Enable Vertical Scaling
```bash
./scale.sh
```
### Shut Down
```bash
./stop.sh
```

## Results <a name="results"></a>
### Relative Sizes of Result Sets
```bash
> FT.SEARCH idx '@num:[1000 2000]' LIMIT 0 0
1) "111701"

> FT.SEARCH idx '@color:{grey}' LIMIT 0 0
1) "322113"

> FT.SEARCH idx '@quote:"little more than kin"' LIMIT 0 0
1) "556113"
```

### Smallest to Largest Intersections - No Vertical Scaling
```bash
FT.SEARCH idx '@num:[1000 2000] @color:{grey} @quote:"little more than kin"' RETURN 1 quote LIMIT 0 10 DIALECT 4
```
```text
ALL STATS
=====================================================================================================
Type            Ops/sec    Avg. Latency     p50 Latency     p99 Latency   p99.9 Latency       KB/sec 
-----------------------------------------------------------------------------------------------------
Ft.searchs        57.66       865.79200      1023.99900      1023.99900      1023.99900        56.14 
Totals            57.66       865.79200      1023.99900      1023.99900      1023.99900       112.28 
```

### Largest to Smallest Intersections - No Vertical Scaling
```bash
FT.SEARCH idx '@quote:"little more than kin" @color:{grey} @num:[1000 2000]' RETURN 1 quote LIMIT 0 10 DIALECT 4
```
```text
ALL STATS
=====================================================================================================
Type            Ops/sec    Avg. Latency     p50 Latency     p99 Latency   p99.9 Latency       KB/sec 
-----------------------------------------------------------------------------------------------------
Ft.searchs        54.37       600.06400       602.11100       602.11100       602.11100        52.94 
Totals            54.37       600.06400       602.11100       602.11100       602.11100       105.88  
```

### TAG First - No Vertical Scaling
```bash
FT.SEARCH idx '@color:{grey} @num:[1000 2000] @quote:\"little more than kin\"' RETURN 1 quote LIMIT 0 10 DIALECT 4
```
```text
ALL STATS
=====================================================================================================
Type            Ops/sec    Avg. Latency     p50 Latency     p99 Latency   p99.9 Latency       KB/sec 
-----------------------------------------------------------------------------------------------------
Ft.searchs        60.09       624.64000       626.68700       626.68700       626.68700        58.51 
Totals            60.09       624.64000       626.68700       626.68700       626.68700       117.02  
```

### TAG Last - No Vertical Scaling
```bash
FT.SEARCH idx '@num:[1000 2000] @quote:\"little more than kin\" @color:{grey}' RETURN 1 quote LIMIT 0 10 DIALECT 4
```
```text
ALL STATS
=====================================================================================================
Type            Ops/sec    Avg. Latency     p50 Latency     p99 Latency   p99.9 Latency       KB/sec 
-----------------------------------------------------------------------------------------------------
Ft.searchs        58.16       624.64000       626.68700       626.68700       626.68700        56.63 
Totals            58.16       624.64000       626.68700       626.68700       626.68700       113.25
```

### Smallest to Largest Intersections - Vertical Scaling Enabled (6 threads)
```bash
FT.SEARCH idx '@num:[1000 2000] @color:{grey} @quote:"little more than kin"' RETURN 1 quote LIMIT 0 10 DIALECT 4
```
```text
ALL STATS
=====================================================================================================
Type            Ops/sec    Avg. Latency     p50 Latency     p99 Latency   p99.9 Latency       KB/sec 
-----------------------------------------------------------------------------------------------------
Ft.searchs       306.78       322.97583       317.43900       561.15100       696.31900       302.89 
Totals           306.78       322.97583       317.43900       561.15100       696.31900       605.77 
```

### Largest to Smallest Intersections - Vertical Scaling Enabled (6 threads)
```bash
FT.SEARCH idx '@quote:"little more than kin" @color:{grey} @num:[1000 2000]' RETURN 1 quote LIMIT 0 10 DIALECT 4
```
```text
ALL STATS
=====================================================================================================
Type            Ops/sec    Avg. Latency     p50 Latency     p99 Latency   p99.9 Latency       KB/sec 
-----------------------------------------------------------------------------------------------------
Ft.searchs       314.13       326.85068       325.63100       692.22300       835.58300       310.14 
Totals           314.13       326.85068       325.63100       692.22300       835.58300       620.28 
```

### TAG First - Vertical Scaling Enabled (6 threads)
```bash
FT.SEARCH idx '@color:{grey} @num:[1000 2000] @quote:\"little more than kin\"' RETURN 1 quote LIMIT 0 10 DIALECT 4
```
```text
 ALL STATS
=====================================================================================================
Type            Ops/sec    Avg. Latency     p50 Latency     p99 Latency   p99.9 Latency       KB/sec 
-----------------------------------------------------------------------------------------------------
Ft.searchs       299.45       330.47184       323.58300       663.55100       749.56700       295.65 
Totals           299.45       330.47184       323.58300       663.55100       749.56700       591.29 
```

### TAG Last - Vertical Scaling Enabled (6 threads)
```bash
FT.SEARCH idx '@num:[1000 2000] @quote:\"little more than kin\" @color:{grey}' RETURN 1 quote LIMIT 0 10 DIALECT 4
```
```text
ALL STATS
=====================================================================================================
Type            Ops/sec    Avg. Latency     p50 Latency     p99 Latency   p99.9 Latency       KB/sec 
-----------------------------------------------------------------------------------------------------
Ft.searchs       301.93       329.74815       337.91900       622.59100       712.70300       298.10 
Totals           301.93       329.74815       337.91900       622.59100       712.70300       596.19 
```