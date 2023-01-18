import json
import os
import base64




def encodetobase64(requestbody):
#message = "Python is fun"
    message_bytes = requestbody.encode('ascii')
    base64_bytes = base64.b64encode(message_bytes)
    base64_message = base64_bytes.decode('ascii')

    print(base64_message)
    return(base64_message)


if __name__ == '__main__':
   encodetobase64('{"scg_message":{"topic":"SCG-Message","event":{"fld-val-list":{"sender_id_alias":"Gladiator","mo_price":0.0095,"companyid":110408,"sender_id_id":"Fy4db1bd4RE9A665JjY4v6","message_body":"Help","message_id":"zTfqxN0RKSn3yKYykjIbP1","to_address":"shortcode2","has_attachment":false,"fragments_count":1,"from_address":"+14023059959","application_id":6946},"evt-tp":"mo_message_received","timestamp":"2020-09-28T20:25:50.774Z"},"attempt":"1","event-id":"qgIwuZ9MRpCuoW9RYoTjkw"},"mom_proxy_received_time":"2020-01-06T00:00:00.000Z"}')