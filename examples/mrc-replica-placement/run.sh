#!/usr/bin/env bash

# Startup
docker-compose up -d

sleep 60

# Create topics
VAR=10
for ((i = 0; i <= VAR; i++)); do
    kafka-topics --bootstrap-server localhost:9092 --create --topic "test-${i}" --partitions 3 --replica-placement ./placement.json --config min.insync.replicas=2
done

echo "Waiting for 30 minutes... You have to collect metrics..."
date
sleep 1800
date

curl 'http://localhost:9090/api/v1/query?query=kafka_server_replicamanager_leadercount' | jq '.data.result[] | { "broker" : .metric.instance, "leader count" : .value[1] }'

echo "Do we need a rebalance?"
kafka-rebalance-cluster --bootstrap-server localhost:9091,localhost:9092,localhost:9093,localhost:9094,localhost:9095,localhost:9096 --rebalance-dry-run

kafka-rebalance-cluster --bootstrap-server localhost:9091,localhost:9092,localhost:9093,localhost:9094,localhost:9095,localhost:9096 --rebalance

echo "Waiting for 5 minutes... Give time to the rebalance process..."
sleep 300

kafka-rebalance-cluster --bootstrap-server localhost:9091,localhost:9092,localhost:9093,localhost:9094,localhost:9095,localhost:9096 --describe

curl 'http://localhost:9090/api/v1/query?query=kafka_server_replicamanager_leadercount' | jq '.data.result[] | { "broker" : .metric.instance, "leader count" : .value[1] }'

sleep 10

docker-compose down -v

# Generate traffic
# VAR=5
# for ((i = 0; i <= VAR; i++)); do
#     kafka-producer-perf-test --topic "test-${i}" --num-records 1000000 --record-size 1000 --throughput 10000000 --producer-props bootstrap.servers=localhost:9092
# done

# get metrics from prometheus
#curl 'http://localhost:9090/api/v1/query?query=kafka_server_replicamanager_leadercount' | jq '.data.result[] | { "broker" : .metric.instance, "leader count" : .value[1] }'
