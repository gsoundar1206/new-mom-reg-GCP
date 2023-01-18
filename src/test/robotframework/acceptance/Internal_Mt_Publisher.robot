*** Settings ***
Resource          Resource_${environment}.txt
Resource          Resource.txt

*** Test Cases ***
001 Publish message to mt topic using internal mt publisher proxy
    [Tags]    SmokeTest    InternalProxy
    ${randomnum}    Generate Random String    22    DRASM12341rtyh
    Log    ${randomnum}
    ${RequestBody}    Catenate    {"recipient": {"type": "PhoneNumber","value": "1${phone_number}"},"messageText": "MOM Test Message from Internal Proxy","trackingId": "${randomnum}","expiration": "2021-10-22T16:03:00.452Z","clientId":${clientId}}
    Log    ${RequestBody}
    ${ResponseBody}    Internal Mt Proxy    ${mt_apigee_host}    ${RequestBody}    ${internal_mt_publisher}
    Log    ${ResponseBody}
    ${result}    Get Response Body
    log    ${result}
    ${responseAsDict}=    Evaluate    json.loads('''${result}''')    modules=json
    Log    ${responseAsDict}
    ${messageid}    convert to string    ${responseAsDict}
    ${finalmessageId}=    remove string    ${messageid}    {'messageIds': ['    ']}
    Log    ${finalmessageId}
    Sleep    15 sec
    ${subscription_message}    Pubsub Msg    ${auth_json}    ${project_id}    ${mt-sms-subscription_topic}    ${finalmessageId}
    Log    ${subscription_message}
    ${mttopicMessage}    convert to string    ${subscription_message}
    Log    ${mttopicMessage}
    Should Contain    ${mttopicMessage}    "value":"1${phone_number}"
    Should Contain    ${mttopicMessage}    "messageText":"MOM Test Message from Internal Proxy",
    Should Contain    ${mttopicMessage}    "trackingId":"${randomnum}",
    Sleep    15 sec
    #################Validating the logs from mom-sms-sender##############################
    ${smssenderlog}    get logs    ${auth_sms_sender}    ${project_id}    ${sms_sender_service}    Finished to process sendSMS
    Log    ${smssenderlog}
    ${LogResult}    Convert To String    ${smssenderlog}
    Should Contain    ${LogResult}    Finished to process sendSMS
    ###############Checking the mt message in billing topic#########################
    Sleep    15 sec
    ${billing_subscription_message}    mt billing    ${auth_sms_sender}    ${project_id}    ${mt_billing_topic}    ${randomnum}
    Log    ${billing_subscription_message}
    ${billing_topicMessage}    Convert to String    ${billing_subscription_message}
    Log    ${billing_topicMessage}
    Should Contain    ${billing_topicMessage}    "status":"SENT"

002 Publish message to mt topic using internal mt publisher proxy with optional +sign in front of phonenumber value(jira:CXPAAS-1894)
    [Tags]    InternalProxy
    ${randomnum}    Generate Random String    22    DRASM12341rtyh
    Log    ${randomnum}
    ${RequestBody}    Catenate    {"recipient": {"type": "PhoneNumber","value": "+1${phone_number}"},"messageText": "MOM Test Message from Internal Proxy","trackingId": "${randomnum}","expiration": "2021-10-22T16:03:00.452Z","clientId":${clientId}}
    Log    ${RequestBody}
    ${ResponseBody}    Internal Mt Proxy    ${mt_apigee_host}    ${RequestBody}    ${internal_mt_publisher}
    Log    ${ResponseBody}
    ${result}    Get Response Body
    log    ${result}
    ${responseAsDict}=    Evaluate    json.loads('''${result}''')    modules=json
    Log    ${responseAsDict}
    ${messageid}    convert to string    ${responseAsDict}
    ${finalmessageId}=    remove string    ${messageid}    {'messageIds': ['    ']}
    Log    ${finalmessageId}
    Sleep    15 sec
    ${subscription_message}    Pubsub Msg    ${auth_json}    ${project_id}    ${mt-sms-subscription_topic}    ${finalmessageId}
    Log    ${subscription_message}
    ${mttopicMessage}    convert to string    ${subscription_message}
    Log    ${mttopicMessage}
    Should Contain    ${mttopicMessage}    "value":"+1${phone_number}"
    Should Contain    ${mttopicMessage}    "messageText":"MOM Test Message from Internal Proxy",
    Should Contain    ${mttopicMessage}    "trackingId":"${randomnum}",
    Sleep    15 sec
    #################Validating the logs from mom-sms-sender##############################
    ${smssenderlog}    get logs    ${auth_sms_sender}    ${project_id}    ${sms_sender_service}    Finished to process sendSMS
    Log    ${smssenderlog}
    ${LogResult}    Convert To String    ${smssenderlog}
    Should Contain    ${LogResult}    Finished to process sendSMS
    ###############Checking the mt message in billing topic#########################
    Sleep    15 sec
    ${billing_subscription_message}    mt billing    ${auth_sms_sender}    ${project_id}    ${mt_billing_topic}    ${randomnum}
    Log    ${billing_subscription_message}
    ${billing_topicMessage}    Convert to String    ${billing_subscription_message}
    Log    ${billing_topicMessage}
    Should Contain    ${billing_topicMessage}    "status":"SENT"
