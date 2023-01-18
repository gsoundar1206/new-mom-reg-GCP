import json, ast
import os
from google.cloud import pubsub_v1
from google.oauth2 import service_account
from robot.api import logger
#pip install --upgrade google-cloud-pubsub
global subscriber

def service_account_auth(auth_json):
    credfile=str(auth_json)
    os.environ['GOOGLE_APPLICATION_CREDENTIALS'] = credfile
    with open( credfile ) as source:
        info=json.load( source )
    credentials=service_account.Credentials.from_service_account_info(info)

def pubsub_msg(auth_json, project_id, subscription_id,apigee_message_id):
    service_account_auth( auth_json )
    subscriber=pubsub_v1.SubscriberClient()
    subscription_path=subscriber.subscription_path( project_id, subscription_id )
    logger.console( project_id )
    logger.console( subscription_id )
    logger.console( apigee_message_id )
    NUM_MESSAGES = 100
    message=""
    with subscriber:  # The subscriber pulls a specific number of messages.
        isFound = False
        while isFound == False:
            response = subscriber.pull(
                request={"subscription": subscription_path, "max_messages": NUM_MESSAGES}
                )
            print(len( response.received_messages ))

            if len( response.received_messages ) == 0:
                isFound=True
                break

            ack_ids=[]

            for received_message in response.received_messages:
                ack_ids.append( received_message.ack_id )
                #print(f"Received: {received_message.message.message_id}")
                if(received_message.message.message_id == apigee_message_id) :
                    isFound = True
                    #print( f"Received: {received_message.message.data}" )
                    message = (str(received_message.message.data,'utf-8'))

            # Acknowledges the received messages so they will not be sent again.
            subscriber.acknowledge(
                request={"subscription": subscription_path, "ack_ids": ack_ids}
               )
    print(message)
    return message


def keyword_resp(auth_json, project_id, subscription_id, parent_message_id):
    service_account_auth( auth_json )
    subscriber=pubsub_v1.SubscriberClient()
    subscription_path=subscriber.subscription_path( project_id, subscription_id )
    logger.console( project_id )
    logger.console( subscription_id )
    logger.console( parent_message_id )
    NUM_MESSAGES=100
    message=""
    with subscriber:  # The subscriber pulls a specific number of messages.
        isFound=False
        while (isFound == False):
            response=subscriber.pull(
                request={"subscription": subscription_path, "max_messages": NUM_MESSAGES}
            )
            print( len( response.received_messages ) )

            if len( response.received_messages ) == 0:
                isFound=True
                break

            ack_ids=[]

            for received_message in response.received_messages:
                ack_ids.append( received_message.ack_id )
                # print( f"Received: {received_message.message.data}" )
                data=json.loads( received_message.message.data )
                if data["trackingId"] == None:
                    continue
                if "parent_msg_id:" in data["trackingId"]:
                    MT_tracking_id=(data["trackingId"]).split( "parent_msg_id:", 1 )[1]
                    print( MT_tracking_id )
                    # print( f"Received: {received_message.message.data}" )
                    if (MT_tracking_id == parent_message_id):
                        isFound=True
                        message=(str( received_message.message.data, 'utf-8' ))

            # Acknowledges the received messages so they will not be sent again.
            subscriber.acknowledge(
                request={"subscription": subscription_path, "ack_ids": ack_ids}
            )
    print( message )
    return message


def final_msg(auth_json, project_id, subscription_id, random_message_id):
    service_account_auth( auth_json )
    subscriber=pubsub_v1.SubscriberClient()
    subscription_path=subscriber.subscription_path( project_id, subscription_id )
    logger.console( project_id )
    logger.console( subscription_id )
    logger.console( random_message_id )
    NUM_MESSAGES=100
    message=""

    with subscriber:  # The subscriber pulls a specific number of messages.
        isFound=False
        while (isFound == False):
            response=subscriber.pull(
                request={"subscription": subscription_path, "max_messages": NUM_MESSAGES}
            )
            print( len( response.received_messages ) )

            if len( response.received_messages ) == 0:
                isFound=True
                print( "hi" )
                break

            ack_ids=[]

            for received_message in response.received_messages:
                ack_ids.append( received_message.ack_id )
                # print( f"Received: {received_message.message.data}" )
                data=json.loads( received_message.message.data )
                #print(received_message.message.data)
                #print( data )
                #print( type(data["scg_message"]) )
                parsedata = json.loads(data["scg_message"])
                #print(parsedata)

                if parsedata["event"]['fld-val-list']["message_id"] == random_message_id:
                #if data["event"]['fld-val-list']["message_id"] == random_message_id:
                    isFound=True
                    #print (str( received_message.message.data, 'utf-8' ))
                    message=(str( received_message.message.data, 'utf-8' ))

            # Acknowledges the received messages so they will not be sent again.
            subscriber.acknowledge(
            request={"subscription": subscription_path, "ack_ids": ack_ids}
            )
        print( message )
        return message

def billing(auth_json, project_id, subscription_id,deliveryReceiptId):
    service_account_auth( auth_json )
    subscriber=pubsub_v1.SubscriberClient()
    subscription_path=subscriber.subscription_path( project_id, subscription_id )
    logger.console( project_id )
    logger.console( subscription_id )
    logger.console( deliveryReceiptId )
    NUM_MESSAGES = 10
    message=""
    with subscriber:  # The subscriber pulls a specific number of messages.
        isFound = False
        while isFound == False:
            response = subscriber.pull(
                request={"subscription": subscription_path, "max_messages": NUM_MESSAGES}
                )
            print(len( response.received_messages ))

            ack_ids=[]

            for received_message in response.received_messages:
                ack_ids.append( received_message.ack_id )
                #print( f"Received: {received_message}" )
                data=json.loads( received_message.message.data)
                print(data["deliveryReceiptId"])

                if(data["deliveryReceiptId"] == deliveryReceiptId) :
                    isFound = True
                    #print( f"Received: {received_message.message.data}" )
                    message = (str(received_message.message.data,'utf-8'))

            # Acknowledges the received messages so they will not be sent again.
            subscriber.acknowledge(
                request={"subscription": subscription_path, "ack_ids": ack_ids}
               )
    print(message)
    return message
    
def mt_billing(auth_json, project_id, subscription_id,trackingId):
    service_account_auth( auth_json )
    subscriber=pubsub_v1.SubscriberClient()
    subscription_path=subscriber.subscription_path( project_id, subscription_id )
    logger.console( project_id )
    logger.console( subscription_id )
    logger.console( trackingId )
    NUM_MESSAGES = 10
    message=""
    with subscriber:  # The subscriber pulls a specific number of messages.
        isFound = False
        while isFound == False:
            response = subscriber.pull(
                request={"subscription": subscription_path, "max_messages": NUM_MESSAGES}
                )
            print(len( response.received_messages ))

            ack_ids=[]

            for received_message in response.received_messages:
                ack_ids.append( received_message.ack_id )
                #print( f"Received: {received_message}" )
                data=json.loads( received_message.message.data)
                print(data["trackingId"])

                if(data["trackingId"] == trackingId) :
                    isFound = True
                    #print( f"Received: {received_message.message.data}" )
                    message = (str(received_message.message.data,'utf-8'))

            # Acknowledges the received messages so they will not be sent again.
            subscriber.acknowledge(
                request={"subscription": subscription_path, "ack_ids": ack_ids}
               )
    print(message)
    return message
    
futures = dict()

def publish(auth_json,project_id, topic_id, request_body):
    service_account_auth( auth_json )
    publisher = pubsub_v1.PublisherClient()
    topic_path = publisher.topic_path(project_id, topic_id)
    data = (request_body)
    futures.update({data: None})
    future = publisher.publish(topic_path, data.encode("utf-8"))
    futures[data] = future
    print(f"Published messages to {topic_path}.")

# Wait for all the publish futures to resolve before exiting.
while futures:
    time.sleep(5)

if __name__ == '__main__':
   #keyword_resp('auth.json', 'ce-cxmo-mom-test-01', 'mom-mt-sms', 'PHRcHX11d2cPH1bPXb413d')
   #keyword_resp('auth.json','ce-cxmo-mom-dev-01','mom.mt-message-in-test-sub', 'PcRac1XRd1HXRa24H1Pa31')
   #pubsub_msg('auth_test.json', 'ce-cxmo-mom-test-01', 'mom-mo-keyword-test', '1912034794185331')
   final_msg('auth_test.json', 'ce-cxmo-mom-test-01', 'mom-mo-final-test-sub', 'mopublisher14')
   #billing( 'auth.json', 'ce-cxmo-mom-test-01', 'mom-mt-sms-billing', '178403ee-47da-45fe-ba21-a679c875e47a' )
   #publish( 'authmomtest.json', 'ce-cxmo-mom-test-01', 'mom-mo-messages', '{"topic":"SCG-Message","event":{"fld-val-list":{"sender_id_alias":"Gladiator","mo_price":0.0095,"company-id":110408,"sender_id_id":"Fy4db1bd4RE9A665JjY4v6","message_body":"Help","message_id":"zTfqxN0RKSn3yKYykjIbP1","to_address":"shortcode2","has_attachment":false,"fragments_count":1,"from_address":"+14023059959","application_id":6946},"evt-tp":"mo_message_received","timestamp":"2020-09-28T20:25:50.774Z"},"attempt":"1","event-id":"qgIwuZ9MRpCuoW9RYoTjkw"}'  )
																																																																																									  