#!/bin/bash
# showcases the ftsb 3 phases for timescaledb
# - 1) data and query generation
# - 2) data loading/insertion
# - 3) query execution
# generate data
tsbs_generate_data --use-case="iot" --seed=123 --scale=100 \
    --timestamp-start="2016-01-01T00:00:00Z" \
    --timestamp-end="2016-01-02T00:00:00Z" \
    --log-interval="10s" --format="timescaledb" \
    | gzip > /tmp/timescaledb-data.gz

# Generate Query
tsbs_generate_queries --use-case="iot" --seed=123 --scale=100 \
    --timestamp-start="2016-01-01T00:00:00Z" \
    --timestamp-end="2016-01-02T00:00:01Z" \
    --queries=1000 --query-type="last-loc" --format="timescaledb" \
    | gzip > /tmp/timescaledb-queries-last-loc.gz

tsbs_generate_queries --use-case="iot" --seed=123 --scale=100 \
    --timestamp-start="2016-01-01T00:00:00Z" \
    --timestamp-end="2016-01-02T00:00:01Z" \
    --queries=1000 --query-type="avg-load" --format="timescaledb" \
    | gzip > /tmp/timescaledb-queries-avg-load.gz

tsbs_generate_queries --use-case="iot" --seed=123 --scale=100 \
    --timestamp-start="2016-01-01T00:00:00Z" \
    --timestamp-end="2016-01-02T00:00:01Z" \
    --queries=1000 --query-type="high-load" --format="timescaledb" \
    | gzip > /tmp/timescaledb-queries-high-load.gz

tsbs_generate_queries --use-case="iot" --seed=123 --scale=100 \
    --timestamp-start="2016-01-01T00:00:00Z" \
    --timestamp-end="2016-01-02T00:00:01Z" \
    --queries=1000 --query-type="long-driving-session" --format="timescaledb" \
    | gzip > /tmp/timescaledb-queries-long-driving-session.gz

# Load Data
cat /tmp/timescaledb-data.gz | gunzip | tsbs_load_timescaledb \
    --host="localhost" --port=5432 --pass="timescale" \
    --user="postgres" --admin-db-name=postgres --workers=8 \
    --in-table-partition-tag=true --chunk-time=1h --do-create-db=true \
    --db-name="timescaledb" --use-hypertable=false \
    --time-index=true --partition-index=true \
    --replication-factor=1 --hash-workers=false \
    --batch-size=5000 --use-jsonb-tags=false \
    --create-metrics-table=true
    
# Execute doesnt work
cat /tmp/timescaledb-queries-last-loc.gz | gunzip | tsbs_run_queries_timescaledb --workers=8 --hosts="localhost" --postgres="user=postgres dbname=timescaledb sslmode=disable" --pass="timescale" --db-name=timescaledb | tee query_timescaledb_timescaledb-last-loc-queries.out
cat /tmp/timescaledb-queries-avg-load.gz | gunzip | tsbs_run_queries_timescaledb --workers=8 --hosts="localhost" --postgres="user=postgres dbname=timescaledb sslmode=disable" --pass="timescale" --db-name=timescaledb | tee query_timescaledb_timescaledb-avg-load-queries.out
cat /tmp/timescaledb-queries-high-load.gz | gunzip | tsbs_run_queries_timescaledb --workers=8 --hosts="localhost" --postgres="user=postgres dbname=timescaledb sslmode=disable" --pass="timescale" --db-name=timescaledb | tee query_timescaledb_timescaledb-high-load-queries.out
cat /tmp/timescaledb-queries-long-driving-session.gz | gunzip | tsbs_run_queries_timescaledb --workers=8 --hosts="localhost" --postgres="user=postgres dbname=timescaledb sslmode=disable" --pass="timescale" --db-name=timescaledb | tee query_timescaledb_timescaledb-long-driving-session-queries.out