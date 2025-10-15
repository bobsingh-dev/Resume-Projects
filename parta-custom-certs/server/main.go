package main
import (
"crypto/tls"
"crypto/x509"
"fmt"
"io"
"log"
"net/http"
"os"
)
func main() {
// Load server cert + key
cert, err := tls.LoadX509KeyPair("certs/server.pem", "certs/server-key.pem")
if err != nil { log.Fatal(err) }


// Trust store: our CA for client auth
caPEM, err := os.ReadFile("certs/ca.pem")
if err != nil { log.Fatal(err) }
pool := x509.NewCertPool(); pool.AppendCertsFromPEM(caPEM)


tlsConf := &tls.Config{
MinVersion: tls.VersionTLS13,
Certificates: []tls.Certificate{cert},
ClientAuth: tls.RequireAndVerifyClientCert,
ClientCAs: pool,
}


http.HandleFunc("/", func(w http.ResponseWriter, r *http.Request) {
io.WriteString(w, "Hello from Part A — mTLS OK!\n")
})


server := &http.Server{ Addr: ":8443", TLSConfig: tlsConf }
fmt.Println("Part A server on https://localhost:8443")
log.Fatal(server.ListenAndServeTLS("", ""))
}
