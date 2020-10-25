import base64

import printer


def decode_base64(data):
    try:
        base64_bytes = data.encode("utf-8")
        bytes = base64.b64decode(base64_bytes)
        return bytes.decode("utf-8")
    except Exception as e:
        printer.error(e)
        return ""
