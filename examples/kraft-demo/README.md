# Kraft - Demo 

## Format logs dir

```bash
kafka-storage format -c $CONFLUENT_HOME/etc/kafka/kraft/server.properties -t a2Fma2FrcmFmdF90ZXN0Cg==
```

## Run the server

```bash
kafka-server-start $CONFLUENT_HOME/etc/kafka/kraft/server.properties
```

## Create topic and events

```bash
kafka-topics --bootstrap-server localhost:9092 --topic orders --create 
ksql-datagen quickstart=orders format=json msgRate=1 topic=orders iterations=100 
```

## Read metadata

```bash 
kafka-dump-log --files /tmp/kraft-combined-logs/orders-0/00000000000000000000.log
kafka-metadata-quorum --bootstrap-server localhost:9092 describe --status
```