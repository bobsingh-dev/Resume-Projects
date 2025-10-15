package main

import (
	"crypto/tls"
	"fmt"
	"io"
	"log"
	"net/http"

	"github.com/spiffe/go-spiffe/v2/spiffeid"
	"github.com/spiffe/go-spiffe/v2/spiffetls/tlsconfig"
	"github.com/spiffe/go-spiffe/v2/workloadapi"
)


func main() {
source, err := workloadapi.NewX509Source(nil)
if err != nil { log.Fatal(err) }
defer source.Close()


td := spiffeid.RequireTrustDomainFromString("example.org")
tlsConf := tlsconfig.MTLSClientConfig(source, source, tlsconfig.AuthorizeMemberOf(td))
tlsConf.MinVersion = tls.VersionTLS13


tr := &http.Transport{ TLSClientConfig: tlsConf }
resp, err := (&http.Client{Transport: tr}).Get("https://envoy-server:8443/")
if err != nil { log.Fatal(err) }
b, _ := io.ReadAll(resp.Body)
fmt.Print(string(b))
}
