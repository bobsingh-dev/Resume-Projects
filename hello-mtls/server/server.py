import http.server, ssl, os

BASE_DIR = os.path.dirname(os.path.abspath(__file__))
CERT_DIR = os.path.join(BASE_DIR, "../certs")

server_address = ('0.0.0.0', 4443)
handler = http.server.SimpleHTTPRequestHandler
httpd = http.server.HTTPServer(server_address, handler)

context = ssl.create_default_context(ssl.Purpose.CLIENT_AUTH)
context.verify_mode = ssl.CERT_REQUIRED
context.load_cert_chain(certfile=f"{CERT_DIR}/server.crt", keyfile=f"{CERT_DIR}/server.key")
context.load_verify_locations(f"{CERT_DIR}/ca.crt")

httpd.socket = context.wrap_socket(httpd.socket, server_side=True)
print("🔒 Server listening on https://localhost:4443 ...")
httpd.serve_forever()
