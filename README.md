# SSL-certs-handbook

## Prerequisite

- Test env: Windows
- Install openssl

## Prepare cert
Target: ca, cert-key, cert, pfx 

### Generate CA
1. Generate RSA
```bash
openssl genrsa -aes256 -out ca-key.pem 4096
```
2. Generate a public CA Cert
```bash
openssl req -new -x509 -sha256 -days 365 -key ca-key.pem -out ca.pem
```

### Optional Stage: View Certificate's Content
```bash
openssl x509 -in ca.pem -text
openssl x509 -in ca.pem -purpose -noout -text
```

### Generate Certificate
1. Create a RSA key
```bash
openssl genrsa -out cert-key.pem 4096
```
2. Create a Certificate Signing Request (CSR)
```bash
openssl req -new -sha256 -subj "/CN=yourcn" -key cert-key.pem -out cert.csr
```
3. Create a `extfile` with all the alternative names
```bash
echo subjectAltName=DNS:your-dns.record,IP:257.10.10.1 >> extfile.cnf
```
4. Create the certificate
```bash
openssl x509 -req -sha256 -days 365 -in cert.csr -CA ca.pem -CAkey ca-key.pem -out cert.pem -extfile extfile.cnf -CAcreateserial
```

### Generate PFX
```bash
openssl pkcs12 -export -out server.pfx -inkey cert-key.pem -in cert.pem
```

### View Thumbprint
```bash
openssl x509 -in cert.pem -noout -fingerprint
```
Note: no need ':'


