# Multiple Listeners

## Prepare the environment

```bash
./run.sh
docker-compose up -d
```

## Questions

How many listeners do we have?

How can I connect to SSL listener?  

`kafka-topics --bootstrap-server localhost:29092 --list --command-config clients/ssl.properties`

How can I connect to SASL_SSL listener?  

`kafka-topics --bootstrap-server localhost:29092 --list --command-config clients/sasl.ssl.properties`