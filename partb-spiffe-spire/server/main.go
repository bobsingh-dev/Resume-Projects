package main
import (
"crypto/tls"
"fmt"
"io"
"log"
"net/http"
"time"


"github.com/spiffe/go-spiffe/v2/spiffeid"
"github.com/spiffe/go-spiffe/v2/spiffetls/tlsconfig"
"github.com/spiffe/go-spiffe/v2/workloadapi"
)
func main() {
source, err := workloadapi.NewX509Source(nil)
if err != nil { log.Fatal(err) }
defer source.Close()


td := spiffeid.RequireTrustDomainFromString("example.org")
tlsConf := tlsconfig.MTLSServerConfig(source, source, tlsconfig.AuthorizeMemberOf(td))
tlsConf.MinVersion = tls.VersionTLS13


http.HandleFunc("/", func(w http.ResponseWriter, r *http.Request) {
io.WriteString(w, "Hello from SPIFFE server — mTLS OK (SVID)!\n")
})


srv := &http.Server{ Addr: ":8443", TLSConfig: tlsConf }
log.Println("SPIFFE server on :8443 (behind Envoy)")
// Hot rotation happens inside source; no restarts needed.
for {
go func(){ _ = srv.ListenAndServeTLS("", "") }()
time.Sleep(24 * time.Hour)
}
_ = tls.Certificate{}
}
