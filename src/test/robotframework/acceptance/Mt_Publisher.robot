*** Settings ***
Resource          Resource_${environment}.txt
Resource          Resource.txt

*** Test Cases ***
Precondition - GENERATE BEARER TOKEN FOR MT
    [Tags]    SmokeTest    Precondition    MTsms
    Create Http Context    ${mt_apigee_host}    https
    Set Request Header    Content-Type    application/x-www-form-urlencoded
    Set Request Header    Authorization    Basic ${mt_basic_auth}
    Set Request Body    grant_type=client_credentials
    Http.POST    ${oauth_endpoint}
    Response Body should Contain    access_token
    ${access_token}    Get Response Body
    log    ${access_token}
    ${json}    Evaluate    json.loads("""${access_token}""")    json
    ${access_token}    Set Variable    ${json ['access_token']}
    Log To Console    ${access_token}[0]
    ${access_token}    Set Variable    ${access_token}
    log    ${access_token}
    Set Global Variable    ${access_token}

001 Publish message to mt topic using mt publisher
    [Tags]    SmokeTest    MTsms
    ${randomnum}    Generate Random String    22    DRASM12341rtyh
    Log    ${randomnum}
    ${RequestBody}    Catenate    {"recipient": {"type": "PhoneNumber","value": "1${phone_number}"},"messageText": "MOM Test Message from mt API.","trackingId": "${randomnum}","expiration": "2021-08-16T01:28:51.977Z","senderAddress": "${sender_address}","received": "2020-11-10T11:00:00.452Z","uuid":"f7852dfb-zzzz-aabb-efe5-1z1zz2299020","clientId": "${clientId}","smsCode": "18557992233"}
    Log    ${RequestBody}
    ${ResponseBody}    Mt Publisher    ${mt_apigee_host}    ${RequestBody}    ${mom_mt_publisher}
    Log    ${ResponseBody}
    ${result}    Get Response Body
    log    ${result}
    ${responseAsDict}=    Evaluate    json.loads('''${result}''')    modules=json
    Log    ${responseAsDict}
    ${messageid}    convert to string    ${responseAsDict}
    ${finalmessageId}=    remove string    ${messageid}    {'messageIds': ['    ']}
    Log    ${finalmessageId}
    Sleep    10 sec
    ${subscription_message}    Pubsub Msg    ${auth_json}    ${project_id}    ${mt-sms-subscription_topic}    ${finalmessageId}
    Log    ${subscription_message}
    ${mttopicMessage}    convert to string    ${subscription_message}
    Log    ${mttopicMessage}
    Should Contain    ${mttopicMessage}    "value":"1${phone_number}"
    Should Contain    ${mttopicMessage}    "messageText":"MOM Test Message from mt API.",
    Should Contain    ${mttopicMessage}    "trackingId":"${randomnum}",
    Sleep    10 sec
    #################Validating the logs from mom-sms-sender##############################
    ${smssenderlog}    get logs    ${auth_sms_sender}    ${project_id}    ${sms_sender_service}    Finished to process sendSMS
    Log    ${smssenderlog}
    ${LogResult}    Convert To String    ${smssenderlog}
    Should Contain    ${LogResult}    Finished to process sendSMS
    ###############Checking the mt message in billing topic#########################
    Sleep    10 sec
    ${billing_subscription_message}    mt billing    ${auth_sms_sender}    ${project_id}    ${mt_billing_topic}    ${randomnum}
    Log    ${billing_subscription_message}
    ${billing_topicMessage}    Convert to String    ${billing_subscription_message}
    Log    ${billing_topicMessage}
    Should Contain    ${billing_topicMessage}    "status":"SENT"
    Should Contain    ${billing_topicMessage}    "smsCode":"18557992233"

002 Publish message to mt topic using mt publisher with optional +sign in front of phonenumber value(jira:CXPAAS-1894)
    [Tags]    SmokeTest    MTsms
    ${randomnum}    Generate Random String    22    DRASM12341rtyh
    Log    ${randomnum}
    ${RequestBody}    Catenate    {"recipient": {"type": "PhoneNumber","value": "+1${phone_number}"},"messageText": "MOM Test Message from mt API.","trackingId": "${randomnum}","expiration": "2021-08-16T01:28:51.977Z","senderAddress": "${sender_address}","received": "2020-11-10T11:00:00.452Z","uuid":"f7852dfb-zzzz-aabb-efe5-1z1zz2299020","clientId": "${clientId}","smsCode": "18557992233"}
    Log    ${RequestBody}
    ${ResponseBody}    Mt Publisher    ${mt_apigee_host}    ${RequestBody}    ${mom_mt_publisher}
    Log    ${ResponseBody}
    ${result}    Get Response Body
    log    ${result}
    ${responseAsDict}=    Evaluate    json.loads('''${result}''')    modules=json
    Log    ${responseAsDict}
    ${messageid}    convert to string    ${responseAsDict}
    ${finalmessageId}=    remove string    ${messageid}    {'messageIds': ['    ']}
    Log    ${finalmessageId}
    Sleep    10 sec
    ${subscription_message}    Pubsub Msg    ${auth_json}    ${project_id}    ${mt-sms-subscription_topic}    ${finalmessageId}
    Log    ${subscription_message}
    ${mttopicMessage}    convert to string    ${subscription_message}
    Log    ${mttopicMessage}
    Should Contain    ${mttopicMessage}    "value":"+1${phone_number}"
    Should Contain    ${mttopicMessage}    "messageText":"MOM Test Message from mt API.",
    Should Contain    ${mttopicMessage}    "trackingId":"${randomnum}",
    Sleep    10 sec
    #################Validating the logs from mom-sms-sender##############################
    ${smssenderlog}    get logs    ${auth_sms_sender}    ${project_id}    ${sms_sender_service}    Finished to process sendSMS
    Log    ${smssenderlog}
    ${LogResult}    Convert To String    ${smssenderlog}
    Should Contain    ${LogResult}    Finished to process sendSMS
    ###############Checking the mt message in billing topic#########################
    Sleep    10 sec
    ${billing_subscription_message}    mt billing    ${auth_sms_sender}    ${project_id}    ${mt_billing_topic}    ${randomnum}
    Log    ${billing_subscription_message}
    ${billing_topicMessage}    Convert to String    ${billing_subscription_message}
    Log    ${billing_topicMessage}
    Should Contain    ${billing_topicMessage}    "status":"SENT"
    Should Contain    ${billing_topicMessage}    "smsCode":"18557992233"
