# Consumer groups 

## Generate sample data

```bash
kafka-topics --bootstrap-server localhost:9092 --topic orders --create --partitions 3 --replication-factor 3 --config min.insync.replicas=2
kafka-topics --bootstrap-server localhost:9092 --topic users --create --partitions 3 --replication-factor 3 --config min.insync.replicas=2
ksql-datagen quickstart=orders format=json msgRate=1 topic=users
ksql-datagen quickstart=orders format=json msgRate=1 topic=orders
# export classpath
export CLASSPATH=$CONFLUENT_HOME/share/java/monitoring-interceptors/monitoring-interceptors-7.3.0.jar
```

## Run consumers - Range Assignor

```bash
kafka-console-consumer \
    --bootstrap-server localhost:9091,localhost:9092,localhost:9093 \
    --group test-group \
    --whitelist "users|orders" \
    --consumer-property "interceptor.classes=io.confluent.monitoring.clients.interceptor.MonitoringConsumerInterceptor" \
    --consumer-property "partition.assignment.strategy=org.apache.kafka.clients.consumer.RangeAssignor" \
    --consumer-property client.id=c1

kafka-console-consumer \
    --bootstrap-server localhost:9092 \
    --group test-group \
    --whitelist "users_kafka_topic_json|orders_kafka_topic_json" \
    --consumer-property "interceptor.classes=io.confluent.monitoring.clients.interceptor.MonitoringConsumerInterceptor" \
    --consumer-property "partition.assignment.strategy=org.apache.kafka.clients.consumer.RangeAssignor" \
    --consumer-property client.id=c2

kafka-console-consumer \
    --bootstrap-server localhost:9092 \
    --group test-group \
    --whitelist "users_kafka_topic_json|orders_kafka_topic_json" \
    --consumer-property "interceptor.classes=io.confluent.monitoring.clients.interceptor.MonitoringConsumerInterceptor" \
    --consumer-property "partition.assignment.strategy=org.apache.kafka.clients.consumer.RangeAssignor" \
    --consumer-property client.id=c3
```

## Run consumers - StickyAssignor

```bash
kafka-console-consumer \
    --bootstrap-server localhost:9092 \
    --group test-group \
    --whitelist "users|orders" \
    --consumer-property "interceptor.classes=io.confluent.monitoring.clients.interceptor.MonitoringConsumerInterceptor" \
    --consumer-property "partition.assignment.strategy=org.apache.kafka.clients.consumer.CooperativeStickyAssignor,org.apache.kafka.clients.consumer.StickyAssignor" \
    --consumer-property client.id=c1

kafka-console-consumer \
    --bootstrap-server localhost:9092 \
    --group test-group \
    --whitelist "users|orders" \
    --consumer-property "interceptor.classes=io.confluent.monitoring.clients.interceptor.MonitoringConsumerInterceptor" \
    --consumer-property "partition.assignment.strategy=org.apache.kafka.clients.consumer.CooperativeStickyAssignor,org.apache.kafka.clients.consumer.StickyAssignor" \
    --consumer-property client.id=c2

kafka-console-consumer \
    --bootstrap-server localhost:9092 \
    --group test-group \
    --whitelist "users|orders" \
    --consumer-property "interceptor.classes=io.confluent.monitoring.clients.interceptor.MonitoringConsumerInterceptor" \
    --consumer-property "partition.assignment.strategy=org.apache.kafka.clients.consumer.CooperativeStickyAssignor,org.apache.kafka.clients.consumer.StickyAssignor" \
    --consumer-property client.id=c3
```

## Check consumer groups

```bash
kafka-consumer-groups \
    --bootstrap-server localhost:9091,localhost:9092,localhost:9093 \
    --group test-group \
    --describe \
    --members \
    --verbose

kafka-consumer-groups \
    --bootstrap-server localhost:9091,localhost:9092,localhost:9093 \
    --group test-group \
    --describe \
    --state

kafka-consumer-groups --bootstrap-server localhost:9092 --group test-group --delete
```