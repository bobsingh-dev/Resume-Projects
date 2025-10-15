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
// Load client cert
cert, err := tls.LoadX509KeyPair("certs/client.pem", "certs/client-key.pem")
if err != nil { log.Fatal(err) }
// Trust server CA
caPEM, _ := os.ReadFile("certs/ca.pem")
pool := x509.NewCertPool(); pool.AppendCertsFromPEM(caPEM)


tr := &http.Transport{ TLSClientConfig: &tls.Config{
MinVersion: tls.VersionTLS13,
Certificates: []tls.Certificate{cert},
RootCAs: pool,
}}
resp, err := (&http.Client{Transport: tr}).Get("https://parta-server:8443/")
if err != nil { log.Fatal(err) }
b, _ := io.ReadAll(resp.Body)
fmt.Print(string(b))
}
