from Crypto.Cipher import DES

def decode_char(c):
    if c == 'a':
        r = '?'
    else:
        r = c
    return ord(r) - ord('!')

def ascii_to_binary(s):
    assert len(s) == 24

    out = [0]*18
    i = 0
    j = 0

    for i in range(0, len(s), 4):
        y = decode_char(s[i + 0])
        y = (y << 6) & 0xffffff

        k = decode_char(s[i + 1])
        y = (y | k) & 0xffffff
        y = (y << 6) & 0xffffff

        k = decode_char(s[i + 2])
        y = (y | k) & 0xffffff
        y = (y << 6) & 0xffffff

        k = decode_char(s[i + 3])
        y = (y | k) & 0xffffff

        out[j+2] = chr(y       & 0xff)
        out[j+1] = chr((y>>8)  & 0xff)
        out[j+0] = chr((y>>16) & 0xff)

        j += 3

    return "".join(out)

def decrypt_password(p):
    r = ascii_to_binary(p)

    r = r[:16]

    d = DES.new("\x01\x02\x03\x04\x05\x06\x07\x08", DES.MODE_ECB)
    r = d.decrypt(r)

    return r.rstrip("\x00")

