#!/usr/bin/env python3

import json
import sys
import time
import urllib.error
import urllib.parse
import urllib.request
import webbrowser


DEFAULT_DEVICE_CODE_ENDPOINT = "https://login.microsoftonline.com/consumers/oauth2/v2.0/devicecode"
DEFAULT_TOKEN_ENDPOINT = "https://login.microsoftonline.com/consumers/oauth2/v2.0/token"
DEFAULT_SCOPE = "XboxLive.signin offline_access"
# Temporary hack: reuse Prism Launcher's public client id for Microsoft auth.
DEFAULT_CLIENT_ID = "c36a9fb6-4f2a-41ff-90bd-ae7cc92031eb"


def fatal(message):
    print(f"error: {message}", file=sys.stderr)
    raise SystemExit(1)


def open_browser(url):
    try:
        return webbrowser.open(url)
    except Exception:
        return False


def post_form(url, data, allow_oauth_error=False):
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
        if allow_oauth_error:
            try:
                return json.loads(body)
            except json.JSONDecodeError:
                return {"error": f"http_{exc.code}", "error_description": body}
        fatal(f"token exchange failed with HTTP {exc.code}: {body}")
    except urllib.error.URLError as exc:
        fatal(f"token exchange failed: {exc}")


def print_result(token_response):
    refresh_token = token_response.get("refresh_token")

    print("")
    if refresh_token is not None:
        print(f"refreshToken: {refresh_token}")


def read_config():
    return {
        "client_id": DEFAULT_CLIENT_ID,
        "device_code_endpoint": DEFAULT_DEVICE_CODE_ENDPOINT,
        "token_endpoint": DEFAULT_TOKEN_ENDPOINT,
        "scope": DEFAULT_SCOPE,
    }


def request_device_code(config):
    return post_form(
        config["device_code_endpoint"],
        {
            "client_id": config["client_id"],
            "scope": config["scope"],
        },
    )


def wait_for_device_token(config, device_response):
    interval = max(int(device_response.get("interval", 5)), 1)
    expires_at = time.time() + max(int(device_response.get("expires_in", 900)), 1)

    while time.time() < expires_at:
        token_response = post_form(
            config["token_endpoint"],
            {
                "grant_type": "urn:ietf:params:oauth:grant-type:device_code",
                "device_code": device_response["device_code"],
                "client_id": config["client_id"],
            },
            allow_oauth_error=True,
        )

        error = token_response.get("error")
        if error is None:
            return token_response
        if error == "authorization_pending":
            time.sleep(interval)
            continue
        if error == "slow_down":
            interval += 5
            time.sleep(interval)
            continue
        if error == "authorization_declined":
            fatal("login was declined in the browser")
        if error == "expired_token":
            fatal("device code expired before login completed")

        description = token_response.get("error_description", error)
        fatal(f"login failed: {description}")

    fatal("timed out waiting for browser login confirmation")


def run_login():
    config = read_config()
    device_response = request_device_code(config)
    verification_uri = device_response.get("verification_uri")
    verification_uri_complete = device_response.get("verification_uri_complete")
    user_code = device_response.get("user_code")

    print("Open this URL to sign in with your Microsoft account:")
    print(verification_uri_complete or verification_uri or "")
    print("")
    if user_code is not None:
        print(f"Code: {user_code}")
    if open_browser(verification_uri_complete or verification_uri or ""):
        print("A browser window was opened for login.")
    else:
        print("Could not open a browser automatically. Open the URL manually.")

    token_response = wait_for_device_token(config, device_response)

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
