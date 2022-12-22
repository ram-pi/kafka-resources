# Consumer batching and offset management

## Run

```bash
docker-compose up -d 
kafka-topics --bootstrap-server localhost:9092 --create --topic test
kafka-console-producer --bootstrap-server localhost:9092 --topic test --producer.config ${PWD}/producer.config
```

## Check batched message on container

```bash
[appuser@kafka3 test-0]$ kafka-dump-log --files 00000000000000000000.log
Dumping 00000000000000000000.log
Log starting offset: 0
baseOffset: 0 lastOffset: 5 count: 6 baseSequence: -1 lastSequence: -1 producerId: -1 producerEpoch: -1 partitionLeaderEpoch: 0 isTransactional: false isControl: false deleteHorizonMs: OptionalLong.empty position: 0 CreateTime: 1669708255530 size: 114 magic: 2 compresscodec: none crc: 3538869124 isvalid: true
```