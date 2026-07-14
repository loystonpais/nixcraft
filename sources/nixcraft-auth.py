#!/usr/bin/env python3

import json
import secrets
import sys
import urllib.error
import urllib.parse
import urllib.request
import webbrowser


DEFAULT_AUTHORIZE_ENDPOINT = "https://login.live.com/oauth20_authorize.srf"
DEFAULT_TOKEN_ENDPOINT = "https://login.live.com/oauth20_token.srf"
DEFAULT_REDIRECT_URI = "https://login.live.com/oauth20_desktop.srf"
DEFAULT_SCOPE = "service::user.auth.xboxlive.com::MBI_SSL offline_access"
DEFAULT_CLIENT_ID = "94d3031d-2d71-404e-8ff6-90f1f249fc1a"


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


def print_result(token_response):
    refresh_token = token_response.get("refresh_token")

    print("")
    if refresh_token is not None:
        print(f"refreshToken: {refresh_token}")


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
    return {
        "client_id": DEFAULT_CLIENT_ID,
        "authorize_endpoint": DEFAULT_AUTHORIZE_ENDPOINT,
        "token_endpoint": DEFAULT_TOKEN_ENDPOINT,
        "redirect_uri": DEFAULT_REDIRECT_URI,
        "scope": DEFAULT_SCOPE,
    }


def run_login():
    config = read_config()
    state = secrets.token_urlsafe(24)
    authorize_url = build_authorize_url(config, state)

    print("Open this URL to sign in with your Microsoft account:")
    print(authorize_url)
    print("")
    if open_browser(authorize_url):
        print("A browser window was opened for login.")
    else:
        print("Could not open a browser automatically. Open the URL manually.")

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

    print_result(token_response)


def main():
    if len(sys.argv) != 1:
        fatal("nixcraft-auth does not accept command-line arguments")
    run_login()


if __name__ == "__main__":
    main()
