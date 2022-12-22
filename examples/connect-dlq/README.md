# Kafka Connect DLQ

## Launch datagen kafka connect
```bash
curl --request PUT \
  --url http://localhost:8083/connectors/pageviews/config \
  --header 'content-type: application/json' \
  --header 'user-agent: vscode-restclient' \
  --data '{"connector.class": "io.confluent.kafka.connect.datagen.DatagenConnector","kafka.topic": "pageviews","quickstart": "pageviews","max.interval": "5000","value.converter": "io.confluent.connect.avro.AvroConverter","value.converter.schema.registry.url": "http://schema-registry:8081","iterations": -1}'
```

## Consume data
```bash
kafka-avro-console-consumer  \
 --bootstrap-server localhost:19092 \
 --topic pageviews  \
 --from-beginning \
 --group avro-group \
 --property schema.registry.url=http://localhost:8181 \
 --property value.schema.id=1
```

## Break the connector 
Producing non avro messages  
```bash
echo $(date) | kafka-console-producer --bootstrap-server localhost:19092 --topic pageviews
```

## Create JDBC Sink Connector with error handling
```bash
curl --request PUT \
  --url http://localhost:8083/connectors/mariadb-sink/config \
  --header 'content-type: application/json' \
  --header 'user-agent: vscode-restclient' \
  --data '{"connector.class": "io.confluent.connect.jdbc.JdbcSinkConnector","topics": "pageviews","tasks.max": 1,"connection.url": "jdbc:mysql://mariadb:3306/DEMO","connection.attempts": 5,"connection.user": "root","connection.password": "root","dialect.name": "MySqlDatabaseDialect","insert.mode": "insert","table.name.format": "${topic}","pk.fields": "viewtime,userid,pageid","auto.create": "true","errors.tolerance": "all","errors.deadletterqueue.topic.name": "dlq","errors.deadletterqueue.topic.replication.factor": 1,"errors.deadletterqueue.context.headers.enable": "true"}'
```

Try to break again the connector. This time you'll not able to do it, you can find bad messages in `dlq` topic. 

## Navigate message in dlq
```bash
kafka-console-consumer --bootstrap-server localhost:19092 --topic dlq --from-beginning --property print.headers=true
```