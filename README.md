# Redis Search - TAG Query + Vertical Scaling Test

## Contents
1.  [Summary](#summary)
2.  [Approach](#approach)
3.  [Features](#features)
4.  [Prerequisites](#prerequisites)
5.  [Usage](#usage)
6.  [Results](#results)


## Summary <a name="summary"></a>
This is a series of shell scripts for testing query speeds against varied queries and search threading.

## Approach <a name="approach"></a>
RE cluster is built, loaded with 10M JSON documents and tested.

## Features <a name="features"></a>
- 3-node Redis Enterprise cluster
- 2-shard RE DB w/Redis JSON + Search
- Riot script for loading 10M JSON documents
- Test script for memtier search queries for TAG at front of query and rear.
- Scale script to enable Redis Search Vertical Scaling (6 threads)

## Prerequisites <a name="prerequisites"></a>
- Docker Compose
- Riot
- memtier_benchmark
- jq

## Usage <a name="usage"></a>
### Build RE Cluster + Load DB
```bash
./start.sh
```
### Test
```bash
./tag-test.sh
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
### TAG-First Search - No Vertical Scaling
```text
ALL STATS
=====================================================================================================
Type            Ops/sec    Avg. Latency     p50 Latency     p99 Latency   p99.9 Latency       KB/sec 
-----------------------------------------------------------------------------------------------------
Ft.searchs        58.75       734.50667      1015.80700      1028.09500      1028.09500        57.66 
Totals            58.75       734.50667      1015.80700      1028.09500      1028.09500       115.32 
```

### TAG-Last Search - No Vertical Scaling
```text
ALL STATS
=====================================================================================================
Type            Ops/sec    Avg. Latency     p50 Latency     p99 Latency   p99.9 Latency       KB/sec 
-----------------------------------------------------------------------------------------------------
Ft.searchs        57.07       878.59200       880.63900       880.63900       880.63900        56.01 
Totals            57.07       878.59200       880.63900       880.63900       880.63900       112.01 
```

### TAG-First Search - Vertical Scaling Enabled (6 threads)
```text
ALL STATS
=====================================================================================================
Type            Ops/sec    Avg. Latency     p50 Latency     p99 Latency   p99.9 Latency       KB/sec 
-----------------------------------------------------------------------------------------------------
Ft.searchs       328.07       304.48884       311.29500       495.61500       557.05500       323.59 
Totals           328.07       304.48884       311.29500       495.61500       557.05500       647.18 
```

### TAG-Last Search - Vertical Scaling Enabled (6 threads)
```text
ALL STATS
=====================================================================================================
Type            Ops/sec    Avg. Latency     p50 Latency     p99 Latency   p99.9 Latency       KB/sec 
-----------------------------------------------------------------------------------------------------
Ft.searchs       316.31       326.08668       319.48700       507.90300       610.30300       311.99 
Totals           316.31       326.08668       319.48700       507.90300       610.30300       623.98 
```