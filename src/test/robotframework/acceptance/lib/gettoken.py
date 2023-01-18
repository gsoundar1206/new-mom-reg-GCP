import requests
import google.auth    
from google.oauth2 import service_account
from google.auth.transport.requests import AuthorizedSession

#service_url = 'https://mom-sms-sender-5fdcrsjqlq-uc.a.run.app'
#key_file = 'authmomtest.json'

def token(service_url, key_file):
    credentials = service_account.IDTokenCredentials.from_service_account_file(key_file, target_audience=service_url)
    request = google.auth.transport.requests.Request()
    credentials.refresh(request)
    token = credentials.token
    print('ID Token:', token)
    return(token)
    
if __name__ == '__main__':
	token('https://mom-sms-sender-5fdcrsjqlq-uc.a.run.app', 'authmomtest.json') 