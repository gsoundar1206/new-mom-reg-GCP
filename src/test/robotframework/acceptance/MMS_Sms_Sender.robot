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

Send MMS using sms sender and check pub/sub
    [Tags]    SmokeTest    MTsms
    ${randomnum}    Generate Random String    22    DRASM12341rtyh
    Log    ${randomnum}
    ${RequestBody}    Catenate    {"recipient": { "type": "PhoneNumber", "value": "14023059959" }, "mediaURLs":["https://firebasestorage.googleapis.com/v0/b/appserver65346.appspot.com/o/images%2FIntrado_logo.png?alt=media&token=be09cb1f-9b6c-4b6b-a4e0-9619066b2658"], "messageText": "Test Message.", "trackingId": "${randomnum}", "expiration": "2021-08-16T01:28:51.977Z", "channel": "1KJPMkuHQkair_o15etpmg", "received": "2020-11-10T11:00:00.452Z", "uuid": "f7852dfb-zzzz-aabb-efe5-221zz2299020" }
    Log    ${RequestBody}
    ${ResponseBody}    MMS SMS Sender    ${mt_apigee_host}    ${RequestBody}    ${mom_mt_publisher}
    Log    ${ResponseBody}
    ${result}    Get Response Body
    log    ${result}
    Sleep    10 sec
    ${subscription_message}    mt billing    ${auth_json}    ${project_id}    ${mt-sms-subscription_topic}    ${randomnum}
    Log    ${subscription_message}
    ${mttopicMessage}    convert to string    ${subscription_message}
    Log    ${mttopicMessage}
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
    Should Contain    ${billing_topicMessage}    "trackingId":"${randomnum}"

Send MMS without the media URL using sms sender and check pub/sub
    [Tags]    SmokeTest    MTsms
    ${randomnum}    Generate Random String    22    DRASM12341rtyh
    Log    ${randomnum}
    ${RequestBody}    Catenate    {"recipient": { "type": "PhoneNumber", "value": "14023059959" }, "messageText": "Test Message.", "trackingId": "${randomnum}", "expiration": "2021-08-16T01:28:51.977Z", "channel": "1KJPMkuHQkair_o15etpmg", "received": "2020-11-10T11:00:00.452Z", "uuid": "f7852dfb-zzzz-aabb-efe5-221zz2299020" }
    Log    ${RequestBody}
    ${ResponseBody}    MMS SMS Sender    ${mt_apigee_host}    ${RequestBody}    ${mom_mt_publisher}
    Log    ${ResponseBody}
    ${result}    Get Response Body
    log    ${result}
    Sleep    10 sec
    ${subscription_message}    mt billing    ${auth_json}    ${project_id}    ${mt-sms-subscription_topic}    ${randomnum}
    Log    ${subscription_message}
    ${mttopicMessage}    convert to string    ${subscription_message}
    Log    ${mttopicMessage}
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
    Should Contain    ${billing_topicMessage}    "trackingId":"${randomnum}"
