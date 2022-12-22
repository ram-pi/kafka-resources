#!/bin/bash

set -x

# move to certs folder
cd ./security

# clean folder
find . -type f ! -name '*.cnf' -delete

# Generate CA cert and key
openssl req -new -nodes -x509 -days 3650 -newkey rsa:2048 -keyout ca.key -out ca.crt -config ca.cnf
cat ca.crt ca.key >ca.pem

# Generate Kafka Server CSR and key
#keytool -genkey -alias kafka-server -keyalg RSA -keystore keystore.jks -keysize 2048 -dname "CN=kafka.server,O=SA,OU=PS,L=Rome,ST=LA,C=IT" -storepass pass123
openssl req -new -newkey rsa:2048 -keyout server.kafka.key -out server.kafka.csr -config server.kafka.cnf -nodes
openssl x509 -req -days 365 -in server.kafka.csr -CA ca.crt -CAkey ca.key -CAcreateserial -out server.kafka.crt -extfile server.kafka.cnf -extensions v3_req
openssl pkcs12 -export -in server.kafka.crt -inkey server.kafka.key -chain -CAfile ca.pem -name "kafka.confluent.local" -out server.kafka.p12 -password pass:test1234

# Create truststore
keytool -keystore truststore.jks -alias CARoot -import -file ca.crt -storepass test1234 -noprompt -storetype PKCS12
#keytool -keystore truststore.jks -alias kafka-server -import -file server.kafka.crt -storepass test1234  -noprompt -storetype PKCS12
keytool -v -importkeystore -srckeystore server.kafka.p12 -srcstoretype PKCS12 -srcstorepass test1234 -destkeystore truststore.jks -deststoretype JKS -storepass test1234 -noprompt

# Create keystore
keytool -importkeystore -deststorepass test1234 -destkeystore server.kafka.keystore.jks \
    -srckeystore server.kafka.p12 \
    -deststoretype PKCS12 \
    -srcstoretype PKCS12 \
    -noprompt \
    -srcstorepass test1234

# Extract CSR from keytool
#keytool -keystore keystore.jks -alias kafka-server -certreq -file kafka.server.csr -storepass pass123

# Sign CSR
#openssl x509 -req -CA ca.crt -CAkey ca.key -in kafka.server.csr -out kafka.server.crt -days 3650 -CAcreateserial

# Check certificate
#openssl x509 -text -noout -in kafka.server.crt

# Importing CA in keystore
#keytool -keystore keystore.jks -alias CARoot -import -file ca.crt -storepass pass123 -noprompt

# Import signed certificate in keystore
#keytool -keystore keystore.jks -alias kafka-server -import -file kafka.server.crt -storepass pass123

# Generate truststore and import ca.crt
#keytool -keystore truststore.jks -alias kafka-server -import -file kafka.server.crt -storepass pass123 -noprompt

# Create file with pass for opening the keystore
echo "test1234" >keystore-creds

# Create file with pass per signed certifcate
echo "test1234" >kafka-server-creds

# openssl utilities
#openssl s_client -showcerts localhost:29092 # retrieve cert from host:port%
