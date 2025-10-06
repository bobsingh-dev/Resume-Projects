.PHONY: all clean run

all: certs/ca.crt certs/server.crt certs/client.crt

certs/ca.crt:
	mkdir -p certs
	openssl req -x509 -newkey rsa:2048 -days 365 -nodes \
		-keyout certs/ca.key -out certs/ca.crt \
		-subj "/CN=MyRootCA"

certs/server.crt: certs/ca.crt
	mkdir -p certs
	echo "subjectAltName=DNS:localhost" > certs/server-ext.cnf
	openssl req -newkey rsa:2048 -nodes \
		-keyout certs/server.key -out certs/server.csr \
		-subj "/CN=localhost"
	openssl x509 -req -in certs/server.csr -CA certs/ca.crt -CAkey certs/ca.key \
		-CAcreateserial -out certs/server.crt -days 365 -sha256 \
		-extfile certs/server-ext.cnf
	rm certs/server-ext.cnf

certs/client.crt: certs/ca.crt
	openssl req -newkey rsa:2048 -nodes \
		-keyout certs/client.key -out certs/client.csr \
		-subj "/CN=mtls-client"
	openssl x509 -req -in certs/client.csr -CA certs/ca.crt -CAkey certs/ca.key \
		-CAcreateserial -out certs/client.crt -days 365 -sha256

run:
	@echo "🔧 Cleaning up old servers..."
	-@pkill -f "server/server.py" 2>/dev/null || true
	@echo "Starting server..."
	python3 server/server.py & sleep 2
	@echo "Running client test..."
	bash client/client.sh
	@echo "✅ mTLS verified between client and server."

clean:
	rm -rf certs/*.crt certs/*.key certs/*.csr certs/*.srl
