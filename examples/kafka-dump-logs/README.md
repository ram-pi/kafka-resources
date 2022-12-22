# Dump logs

## CLI 

```bash
kafka-run-class kafka.tools.DumpLogSegments --files /var/lib/kafka/data/__consumer_offsets-0/00000000000000000000.log --offsets-decode
```