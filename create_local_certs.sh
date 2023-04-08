#!/bin/bash

read -p "Provide domain: " -r DOMAIN
CA_CERT_NAME="localCA"


openssl genrsa -des3 -passout pass:12345 -out ${CA_CERT_NAME}.pass.key 2048
openssl rsa -in ${CA_CERT_NAME}.pass.key -passin pass:12345 -out ${CA_CERT_NAME}.key
openssl req -x509 -new -nodes -key ${CA_CERT_NAME}.key -sha256 -days 1825 -subj "/C=/ST=/L=/O=/CN=${CA_CERT_NAME}" -out ${CA_CERT_NAME}.pem

# create self-signed certificate from created CA
openssl genrsa -out ${DOMAIN}.key 2048
openssl req -new -key ${DOMAIN}.key -subj "/C=/ST=/L=/O=/CN=${DOMAIN}" -out ${DOMAIN}.csr
echo authorityKeyIdentifier=keyid,issuer > ${DOMAIN}.ext
echo "basicConstraints=CA:FALSE" >> ${DOMAIN}.ext
echo keyUsage = digitalSignature, nonRepudiation, keyEncipherment, dataEncipherment >> ${DOMAIN}.ext
echo subjectAltName = @alt_names >> ${DOMAIN}.ext
echo "" >> ${DOMAIN}.ext
echo [alt_names] >> ${DOMAIN}.ext
echo DNS.1 = ${DOMAIN} >> ${DOMAIN}.ext
openssl x509 -req -in ${DOMAIN}.csr -CA ${CA_CERT_NAME}.pem -CAkey ${CA_CERT_NAME}.key -CAcreateserial -out ${DOMAIN}.cst -days 1825 -sha256 -extfile ${DOMAIN}.ext
mkdir -p "${DOMAIN}"
cp ${DOMAIN}.cst "${DOMAIN}/fullchain.pem"
cp ${DOMAIN}.key "${DOMAIN}/privkey.pem"
cp ${CA_CERT_NAME}.pem "${DOMAIN}/chain.pem"
