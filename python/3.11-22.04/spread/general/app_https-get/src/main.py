#!/usr/bin/python3.11

import http.client
import ssl


def main():
    url = "www.python.org"
    try:
        conn = http.client.HTTPSConnection(url, context=ssl.SSLContext())
        conn.request("GET", "/")
        resp = conn.getresponse()
    except Exception as e:
        print(f"cannot connect to {url}: {e}")
        exit(1)
    print(resp.status, resp.reason)


if __name__ == "__main__":
    main()
