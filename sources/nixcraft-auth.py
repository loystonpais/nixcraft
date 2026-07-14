#!/usr/bin/env python3

import http.server
import json
import os
import secrets
import socketserver
import sys
import threading
import urllib.error
import urllib.parse
import urllib.request
import webbrowser


DEFAULT_AUTHORIZE_ENDPOINT = "https://login.live.com/oauth20_authorize.srf"
DEFAULT_TOKEN_ENDPOINT = "https://login.live.com/oauth20_token.srf"
DEFAULT_REDIRECT_URI = "https://login.live.com/oauth20_desktop.srf"
DEFAULT_SCOPE = "service::user.auth.xboxlive.com::MBI_SSL offline_access"
CLIENT_ID_ENV = "NIXCRAFT_AUTH_CLIENT_ID"
AUTHORIZE_ENDPOINT_ENV = "NIXCRAFT_AUTH_AUTHORIZE_ENDPOINT"
TOKEN_ENDPOINT_ENV = "NIXCRAFT_AUTH_TOKEN_ENDPOINT"
REDIRECT_URI_ENV = "NIXCRAFT_AUTH_REDIRECT_URI"
SCOPE_ENV = "NIXCRAFT_AUTH_SCOPE"


def fatal(message):
    print(f"error: {message}", file=sys.stderr)
    raise SystemExit(1)


def open_browser(url):
    try:
        return webbrowser.open(url)
    except Exception:
        return False


def post_form(url, data):
    payload = urllib.parse.urlencode(data).encode("utf-8")
    request = urllib.request.Request(
        url,
        data=payload,
        headers={"Content-Type": "application/x-www-form-urlencoded"},
        method="POST",
    )

    try:
        with urllib.request.urlopen(request) as response:
            return json.load(response)
    except urllib.error.HTTPError as exc:
        body = exc.read().decode("utf-8", errors="replace")
        fatal(f"token exchange failed with HTTP {exc.code}: {body}")
    except urllib.error.URLError as exc:
        fatal(f"token exchange failed: {exc}")


def extract_code_from_text(text):
    text = text.strip()
    if not text:
        return None

    parsed = urllib.parse.urlparse(text)
    if parsed.scheme and parsed.netloc:
        query = urllib.parse.parse_qs(parsed.query)
        if "error" in query:
            description = query.get("error_description", ["unknown error"])[0]
            fatal(f"login failed: {description}")
        codes = query.get("code")
        if codes:
            return codes[0]
        return None

    return text


def wait_for_manual_code(expected_state):
    print("Paste the final redirected URL, or paste the code directly.")
    while True:
        text = input("> ").strip()
        if not text:
            print("Input was empty. Try again.", file=sys.stderr)
            continue

        parsed = urllib.parse.urlparse(text)
        if parsed.scheme and parsed.netloc:
            query = urllib.parse.parse_qs(parsed.query)
            if "error" in query:
                description = query.get("error_description", ["unknown error"])[0]
                fatal(f"login failed: {description}")

            callback_state = query.get("state", [None])[0]
            if callback_state is not None and callback_state != expected_state:
                fatal("received redirected URL with an unexpected state value")

        code = extract_code_from_text(text)
        if code:
            return code
        print("Could not find a code in that input. Try again.", file=sys.stderr)


def make_loopback_waiter(redirect_uri, expected_state):
    parsed = urllib.parse.urlparse(redirect_uri)
    host = parsed.hostname
    port = parsed.port
    path = parsed.path or "/"

    if parsed.scheme != "http" or host not in {"127.0.0.1", "localhost"} or port is None:
        return None

    result = {
        "code": None,
        "error": None,
        "state": None,
        "event": threading.Event(),
    }

    class CallbackHandler(http.server.BaseHTTPRequestHandler):
        def log_message(self, format, *args):
            return

        def do_GET(self):
            request_url = urllib.parse.urlparse(self.path)
            if request_url.path != path:
                self.send_response(404)
                self.end_headers()
                return

            query = urllib.parse.parse_qs(request_url.query)
            code = query.get("code", [None])[0]
            error = query.get("error_description", query.get("error", [None]))[0]
            callback_state = query.get("state", [None])[0]

            if callback_state != expected_state:
                body = "Login callback ignored due to an unexpected state value.\n"
                status = 400
            elif error is None and code is None:
                body = "Login callback ignored because it did not include a code.\n"
                status = 400
            else:
                result["code"] = code
                result["error"] = error
                result["state"] = callback_state
                result["event"].set()
                if error is None and code is not None:
                    body = (
                        "Login succeeded. You can close this tab and return to nixcraft-auth.\n"
                    )
                    status = 200
                else:
                    body = "Login failed. You can close this tab and return to nixcraft-auth.\n"
                    status = 400

            encoded = body.encode("utf-8")
            self.send_response(status)
            self.send_header("Content-Type", "text/plain; charset=utf-8")
            self.send_header("Content-Length", str(len(encoded)))
            self.end_headers()
            self.wfile.write(encoded)

    class ReusableTCPServer(socketserver.TCPServer):
        allow_reuse_address = True

    try:
        server = ReusableTCPServer((host, port), CallbackHandler)
    except OSError as exc:
        fatal(f"could not listen on {host}:{port}: {exc}")

    thread = threading.Thread(target=server.serve_forever, daemon=True)
    thread.start()

    def wait(timeout_seconds):
        if not result["event"].wait(timeout_seconds):
            server.shutdown()
            thread.join()
            server.server_close()
            fatal("timed out waiting for the browser login callback")

        server.shutdown()
        thread.join()
        server.server_close()

        if result["state"] != expected_state:
            fatal("received callback with an unexpected state value")
        if result["error"] is not None:
            fatal(f"login failed: {result['error']}")
        if result["code"] is None:
            fatal("login callback did not include a code")

        return result["code"]

    return wait


def print_result(config, token_response):
    refresh_token = token_response.get("refresh_token")
    access_token = token_response.get("access_token")

    print("")
    if refresh_token is not None:
        print(f"refreshToken: {refresh_token}")
    if access_token is not None:
        print(f"microsoftAccessToken: {access_token}")
    print(f"clientId: {config['client_id']}")
    print(f"authorizeEndpoint: {config['authorize_endpoint']}")
    print(f"tokenEndpoint: {config['token_endpoint']}")
    print(f"redirectUri: {config['redirect_uri']}")
    print(f"scope: {config['scope']}")


def build_authorize_url(config, state):
    query = urllib.parse.urlencode(
        {
            "client_id": config["client_id"],
            "response_type": "code",
            "redirect_uri": config["redirect_uri"],
            "scope": config["scope"],
            "state": state,
        }
    )
    return f"{config['authorize_endpoint']}?{query}"


def read_config():
    client_id = os.environ.get(CLIENT_ID_ENV)
    if not client_id:
        fatal(
            f"set {CLIENT_ID_ENV} before running nixcraft-auth"
        )

    return {
        "client_id": client_id,
        "authorize_endpoint": os.environ.get(AUTHORIZE_ENDPOINT_ENV, DEFAULT_AUTHORIZE_ENDPOINT),
        "token_endpoint": os.environ.get(TOKEN_ENDPOINT_ENV, DEFAULT_TOKEN_ENDPOINT),
        "redirect_uri": os.environ.get(REDIRECT_URI_ENV, DEFAULT_REDIRECT_URI),
        "scope": os.environ.get(SCOPE_ENV, DEFAULT_SCOPE),
    }


def run_login():
    config = read_config()
    state = secrets.token_urlsafe(24)
    authorize_url = build_authorize_url(config, state)
    loopback_waiter = make_loopback_waiter(config["redirect_uri"], state)

    print("Open this URL to sign in with your Microsoft account:")
    print(authorize_url)
    print("")
    if open_browser(authorize_url):
        print("A browser window was opened for login.")
    else:
        print("Could not open a browser automatically. Open the URL manually.")

    if loopback_waiter is not None:
        code = loopback_waiter(300)
    else:
        code = wait_for_manual_code(state)

    token_response = post_form(
        config["token_endpoint"],
        {
            "client_id": config["client_id"],
            "code": code,
            "grant_type": "authorization_code",
            "redirect_uri": config["redirect_uri"],
            "scope": config["scope"],
        },
    )

    refresh_token = token_response.get("refresh_token")
    if not refresh_token:
        fatal("token exchange succeeded but did not return a refresh token")

    print_result(config, token_response)


def main():
    if len(sys.argv) != 1:
        fatal("nixcraft-auth does not accept command-line arguments")
    run_login()


if __name__ == "__main__":
    main()
