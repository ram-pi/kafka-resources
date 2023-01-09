#!/usr/bin/env bash

# generate traffic
ksql-datagen quickstart=users format=json msgRate=1 bootstrap-server=localhost:9092 topic=users schemaRegistryUrl=http://localhost:8081 iterations=10

# create the link
kafka-cluster-links --bootstrap-server localhost:29092 --create --link dr-link --config bootstrap.servers=kafka:19092

# mirror topics
kafka-mirrors --create --mirror-topic users --link dr-link --bootstrap-server localhost:29092

# create topic filter
# https://docs.confluent.io/platform/current/multi-dc-deployments/cluster-linking/mirror-topics-cp.html#example-filters
# filters.json
tee -a filters.json <<EOF
{
    "topicFilters": [
        {
            "name": "*",
            "patternType": "LITERAL",
            "filterType": "INCLUDE"
        }
    ]
}
EOF

# generate traffic
ksql-datagen quickstart=orders format=avro msgRate=1 bootstrap-server=localhost:9092 topic=orders schemaRegistryUrl=http://localhost:8081 iterations=10

# create the link with auto create
kafka-cluster-links --bootstrap-server localhost:29092 --create --link dr-link-all-topics --config bootstrap.servers=kafka:19092,auto.create.mirror.topics.enable=true --topic-filters-json-file filters.json

# wait for replication
sleep 60

# check data
set -x
kcat -b localhost:9092 -C -o beginning -t users -e
kcat -b localhost:29092 -C -o beginning -t users -e
kcat -b localhost:9092 -C -o beginning -t orders -e -s key=s -s value=avro -r http://localhost:8081
kcat -b localhost:29092 -C -o beginning -t orders -e -s key=s -s value=avro -r http://localhost:8081
