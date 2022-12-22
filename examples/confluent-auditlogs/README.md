# Audit logs configuration

## Startup

```bash
git clone git@github.com:vdesabou/kafka-docker-playground.git 
cd kafka-docker-playground/environment/rbac-sasl-plain/
./start
```

## Audit logs properties example

```bash
{
    "destinations": {
        "bootstrap_servers": [
            "localhost:9092"
        ],
        "topics": {
            "confluent-audit-log-events": {
                "retention_ms": 7776000000
            }
        }
    },
    "default_topics": {
        "allowed": "confluent-audit-log-events",
        "denied": "confluent-audit-log-events"
    },
    "routes": {
        "crn:///kafka=*/topic=test": {
            "management": {
                "denied": "",
                "allowed": ""
            },
            "consume": {
                "denied": "confluent-audit-log-events",
                "allowed": "confluent-audit-log-events"
            },
            "describe": {
                "denied": "confluent-audit-log-events",
                "allowed": "confluent-audit-log-events"
            },
            "authorize": {
                "denied": "confluent-audit-log-events",
                "allowed": "confluent-audit-log-events"
            },
            "produce": {
                "denied": "",
                "allowed": ""
            }
        }
    }
}
```

## Consume audit logs

```bash
kafka-console-consumer --bootstrap-server localhost:9092 --topic confluent-audit-log-events --from-beginning --consumer.config ./scripts/security/client_sasl_plain.config
```

## Sample traffic

```bash
kcat -b localhost:9092 -L -X security.protocol=SASL_PLAINTEXT  -X sasl.username=admin -X sasl.password=admin-secret -X sasl.mechanisms=PLAIN
kafka-topics --bootstrap-server localhost:9092 --create --topic test --command-config ./scripts/security/client_sasl_plain.config
kafka-console-producer --bootstrap-server localhost:9092 --topic test  --producer.config ./scripts/security/client_sasl_plain.config
```

## Update audit-logs configuration 

```bash
confluent login --url localhost:8091
confluent audit-log config describe
confluent audit-log config describe > audit.json
confluent audit-log config update --file audit.json
```

## Shutdown

```bash
./stop.sh
```

## Note

To upload properly the audit logs configuration make sure you're are using one of these configurations:

```bash
"destinations": {
        "bootstrap_servers": [
            "localhost:9092"
        ],
```

or (in the kafka broker server.properties)

```bash
confluent.security.event.logger.exporter.kafka.bootstrap.servers
```