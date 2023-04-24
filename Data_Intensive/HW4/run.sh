#!/bin/bash
# showcases the ftsb 3 phases for timescaledb
# - 1) data and query generation
# - 2) data loading/insertion
# - 3) query execution
cd $GOPATH/src/github.com/timescale/tsbs
# generate data
tsbs_generate_data --use-case="iot" --seed=123 --scale=10 \
    --timestamp-start="2016-01-01T00:00:00Z" \
    --timestamp-end="2016-01-02T00:00:00Z" \
    --log-interval="10s" --format="timescaledb" \
    | gzip > /tmp/timescaledb-data.gz

# Generate Query
tsbs_generate_queries --use-case="iot" --seed=123 --scale=10 \
    --timestamp-start="2016-01-01T00:00:00Z" \
    --timestamp-end="2016-01-02T00:00:01Z" \
    --queries=1000 --query-type="last-loc" --format="timescaledb" \
    | gzip > /tmp/timescaledb-queries-last-loc.gz

tsbs_generate_queries --use-case="iot" --seed=123 --scale=10 \
    --timestamp-start="2016-01-01T00:00:00Z" \
    --timestamp-end="2016-01-02T00:00:01Z" \
    --queries=1000 --query-type="avg-load" --format="timescaledb" \
    | gzip > /tmp/timescaledb-queries-avg-load.gz

tsbs_generate_queries --use-case="iot" --seed=123 --scale=10 \
    --timestamp-start="2016-01-01T00:00:00Z" \
    --timestamp-end="2016-01-02T00:00:01Z" \
    --queries=1000 --query-type="high-load" --format="timescaledb" \
    | gzip > /tmp/timescaledb-queries-high-load.gz

tsbs_generate_queries --use-case="iot" --seed=123 --scale=10 \
    --timestamp-start="2016-01-01T00:00:00Z" \
    --timestamp-end="2016-01-02T00:00:01Z" \
    --queries=1000 --query-type="long-driving-session" --format="timescaledb" \
    | gzip > /tmp/timescaledb-queries-long-driving-session.gz

# Load Data Doesnt work
cat /tmp/timescaledb-data.gz | gunzip | tsbs_load_timescaledb \
    --host="localhost" --port=5432 --pass="timescale" \
    --user="postgres" --admin-db-name=postgres --workers=8  \
    --in-table-partition-tag=false --chunk-time=8h --do-create-db=true
    
# Execute
cat /tmp/queries/timescaledb-last-loc-queries.gz | gunzip | query_benchmarker_timescaledb --workers=8 --limit=1000 --hosts="localhost" --postgres="user=postgres sslmode=disable"  | tee query_timescaledb_timescaledb-last-loc-queries.out
cat /tmp/queries/timescaledb-avg-load-queries.gz | gunzip | query_benchmarker_timescaledb --workers=8 --limit=1000 --hosts="localhost" --postgres="user=postgres sslmode=disable"  | tee query_timescaledb_timescaledb-avg-load-queries.out
cat /tmp/queries/timescaledb-high-load-queries.gz | gunzip | query_benchmarker_timescaledb --workers=8 --limit=1000 --hosts="localhost" --postgres="user=postgres sslmode=disable"  | tee query_timescaledb_timescaledb-high-load-queries.out
cat /tmp/queries/timescaledb-long-driving-session-queries.gz | gunzip | query_benchmarker_timescaledb --workers=8 --limit=1000 --hosts="localhost" --postgres="user=postgres sslmode=disable"  | tee query_timescaledb_timescaledb-long-driving-session-queries.out