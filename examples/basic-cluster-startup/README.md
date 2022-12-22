# Basic operations

## Create a new topic
`kafka-topics --bootstrap-server localhost:9091,localhost:9092,localhost:9093 --create --topic demo --partitions 3 --replication-factor 3`

What are partitions?
What is the purpose of replication factor?

## Describe topic
`kafka-topics --bootstrap-server localhost:9091,localhost:9092,localhost:9093  --topic demo --describe` 

What are replicas?  
What is ISR?

## Produce data
`echo $(date) | kafka-console-producer --bootstrap-server localhost:9091,localhost:9092,localhost:9093 --topic test`
`echo $(date) | kafka-console-producer --bootstrap-server localhost:9092 --topic test --request-required-acks -1`

What is the ack?

## Consumer data
`kafka-console-consumer --bootstrap-server localhost:9091,localhost:9092,localhost:9093 --topic test --group demo-group --from-beginning`

What does it mean __from-beginning__?

## Describe the consumer group
`kafka-consumer-groups --bootstrap-server localhost:9091,localhost:9092,localhost:9093 --group demo-group --describe`
`kafka-consumer-groups --bootstrap-server localhost:9091,localhost:9092,localhost:9093 --group demo-group --describe --state`

What is the lag?
What is the group coordinator?
What is the assignment-strategy?

## Which client?
https://docs.confluent.io/platform/current/clients/index.html#ak-clients
https://docs.confluent.io/platform/current/app-development/kafkacat-usage.html

`kcat -b localhost:9091,localhost:9092,localhost:9093 -L`