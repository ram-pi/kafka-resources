import sys

from kafka import KafkaProducer

argv = sys.argv[1:]
bootstrap = argv[0]
# print(bootstrap)

k = KafkaProducer(bootstrap_servers=bootstrap)
print(k.config)
