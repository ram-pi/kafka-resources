# MRC - Replica Placement

## Broker placement

|broker|rack|
|---|---|
|1|rack-0|
|4|rack-0|
|2|rack-1|
|5|rack-1|
|3|rack-2|
|6|rack-2|

## Create new topic

```bash
kafka-topics --bootstrap-server localhost:9092 --create --topic test --partitions 3 --replica-placement ./placement.json --config min.insync.replicas=2
```

### Replica Placement

```json
{
    "version": 2,
    "replicas": [
      {
        "count": 1,
        "constraints": {
          "rack": "rack-0"
        }
      },
      {
        "count": 1,
        "constraints": {
          "rack": "rack-1"
        }
      },
      {
        "count": 1,
        "constraints": {
          "rack": "rack-2"
        }
      }
    ],
    "observers": [ 
      {
        "count": 1,
        "constraints": {
          "rack": "rack-2"
        }
      }
    ],
    "observerPromotionPolicy": "under-min-isr"
  }
```

## Check the distribution

```bash
kafka-topics --bootstrap-server localhost:9092 --describe --topic test
Topic: test   TopicId: oST24ElVTZi4lZe_z9nPIw PartitionCount: 3       ReplicationFactor: 4    Configs: min.insync.replicas=2,confluent.placement.constraints={"observerPromotionPolicy":"under-min-isr","version":2,"replicas":[{"count":1,"constraints":{"rack":"rack-0"}},{"count":1,"constraints":{"rack":"rack-1"}},{"count":1,"constraints":{"rack":"rack-2"}}],"observers":[{"count":1,"constraints":{"rack":"rack-2"}}]}
        Topic: test   Partition: 0    Leader: 4       Replicas: 4,2,3,6       Isr: 4,2,3      Offline:        Observers: 6
        Topic: test   Partition: 1    Leader: 1       Replicas: 1,5,6,3       Isr: 1,5,6      Offline:        Observers: 3
        Topic: test   Partition: 2    Leader: 4       Replicas: 4,2,3,6       Isr: 4,2,3      Offline:        Observers: 6
```

## Test even distribution

```bash
./run.sh
```

## Check for rebalances

```bash
kafka-rebalance-cluster --bootstrap-server localhost:9091,localhost:9092,localhost:9093,localhost:9094,localhost:9095,localhost:9096 --describe
kafka-rebalance-cluster --bootstrap-server localhost:9091,localhost:9092,localhost:9093,localhost:9094,localhost:9095,localhost:9096 --rebalance-dry-run
```