# ksqlDB

## Generate sample data 

Use (https://www.confluent.io/hub/confluentinc/kafka-connect-datagen)[https://www.confluent.io/hub/confluentinc/kafka-connect-datagen] to create sample data.  
Suggested quickstarts: users, clickstream

## Print data 

```sql
print users from beginning limit 10;
```

## Create streams

```sql
CREATE STREAM USERS WITH (VALUE_FORMAT='AVRO', PARTITIONS=3, KAFKA_TOPIC='users');
CREATE STREAM CLICKSTREAMS WITH (VALUE_FORMAT='AVRO', PARTITIONS=3, KAFKA_TOPIC='clickstreams');
```

## Querying 

```sql
-- push
SELECT * 
FROM USERS 
WHERE ITEMID='Item_92'
EMIT CHANGES;

-- pull
SELECT * 
FROM USERS 
WHERE ITEMID='Item_92';
```