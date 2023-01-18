import os
from google.oauth2 import service_account
from robot.api import logger
from google.cloud import logging
from google.cloud.logging import DESCENDING
import json
from google.cloud.logging import Client

def service_account_auth(authmomtest_json):
	credfile=str(authmomtest_json)
	os.environ['GOOGLE_APPLICATION_CREDENTIALS'] = credfile
	with open( credfile ) as source:
		info=json.load( source )
	credentials=service_account.Credentials.from_service_account_info(info)

def get_logs(authmomtest_json, project_id, service_name, delivery_receipt_id):
    service_account_auth( authmomtest_json )
    projectName=project_id
    myFilter=f'resource.type:cloud_run_revision AND resource.labels.service_name:{service_name} AND severity:default AND {delivery_receipt_id}'
    # myFilter = myFilter AND "98d81621-1d0d-40c0-88dc-e915cadb3cc0"
    client=Client( project=projectName )
    entries=client.list_entries( order_by=DESCENDING, filter_=myFilter )

    for entry in entries:
        if isinstance( entry.payload, dict ):
            # print(entry.payload)
            # print( entry.payload["message"])
            # return(entry.payload["message"])
            # print(str(entry.payload["message"], 'utf-8'))
            # return(str(entry.payload["message"], 'utf-8'))
            print( str( entry.payload["message"] ) )
            return (str( entry.payload["message"] ))
            # break
        if isinstance( entry.payload, str ):
            print( entry.payload )
            break
        else:
            print( "No logs found" )


def get_keywordresponder_logs(authmomtest_json, project_id, service_name,randomnum):
    service_account_auth(authmomtest_json)
    projectName = project_id
    filter_condition = "Processed MT response for MO message_id "+str(randomnum)
    myFilter = f'resource.type:cloud_run_revision AND resource.labels.service_name:{service_name} AND {filter_condition}'
    client = Client(project = projectName)
    entries = client.list_entries(order_by=DESCENDING, filter_ = myFilter)

    for entry in entries:
        #print(entry)
        if isinstance(entry.payload, dict):
            print(entry.payload["message"])
            return (entry.payload["message"])

        else:
            print("No logs found")
            return ("No logs found")

    print ("no entry found with the filter condition")
    return ("no entry found with the filter condition")

if __name__ == '__main__':
	#get_logs('authmomtest.json', 'ce-cxmo-mom-test-01', 'mom-sms-sender', "Finished to process sendSMS")
    get_keywordresponder_logs( 'authmomtest.json', 'ce-cxmo-mom-test-01', 'mom-keyword-responder', 'vptest08')