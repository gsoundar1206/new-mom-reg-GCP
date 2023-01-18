*** Settings ***
Resource          Resource.txt
Resource          Resource_${environment}.txt

*** Test Cases ***
Precondition - GENERATE BEARER TOKEN
    [Tags]    SmokeTest    Precondition    smssender
    ${Bearer}=    token    https://${sms_sender_host}    ${auth_sms_sender}
    log    ${Bearer}
    Set Global Variable    ${Bearer}

Send a message directly to SMS_Sender cloud run validating the logs
    [Tags]    SmokeTest    smssender
    ${randomnum}    Generate Random String    22    DRASM12341rtyh
    Log    ${randomnum}
    ${RequestBody}    Catenate    {"recipient": {"type": "PhoneNumber", "value": "1${phone_number}"}, "messageText": "MOM Test ", "trackingId": "${randomnum}", "expiration": "2021-08-16T01:28:51.977Z", "senderAddress": "${sender_address}", "received": "2020-11-10T11:00:00.452Z", "uuid": "f7852ffb-auto-test-smss-001100001111", "clientId": "${clientId}", "smsCode": "18557992233" }
    Log    ${RequestBody}
    ${ResponseBody}    Sms Sender    ${sms_sender_host}    ${RequestBody}    ${sms_sender_method}
    Log    ${ResponseBody}
    ${Result}    Convert to String    ${ResponseBody}
    Log    ${Result}
    Should Contain    ${Result}    200
    Should Contain    ${Result}    SENT
    Sleep    15s
    #################Validating the logs from mom-sms-sender##############################
    ${smssenderlog}    get logs    ${auth_sms_sender}    ${project_id}    ${sms_sender_service}    Finished to process sendSMS
    Log    ${smssenderlog}
    ${LogResult}    Convert To String    ${smssenderlog}
    Should Contain    ${LogResult}    Finished to process sendSMS

Send a message directly to SMS_Sender cloud run validating mock service logs
    [Tags]    smssender    TestOnly
    ${randomnum}    Generate Random String    22    RPDFG12341gnxz
    Log    ${randomnum}
    ${RequestBody}    Catenate    {"recipient": {"type": "PhoneNumber", "value": "1${phone_number}"}, "messageText": "MOM Test ", "trackingId": "${randomnum}", "expiration": "2021-08-16T01:28:51.977Z", "senderAddress": "${sender_address}", "received": "2020-11-10T11:00:00.452Z", "uuid": "f7852ffb-auto-test-smss-001100001111", "clientId": "${clientId}", "smsCode": "18557992233" }
    ${ResponseBody}    Sms Sender    ${sms_sender_host}    ${RequestBody}    ${sms_sender_method}
    Log    ${ResponseBody}
    Response Status Code Should Equal    200
    Response Body should Contain    SENT
    ${responsebody}    Get Response Body
    Log    ${responsebody}
    ${Result}    Convert to String    ${responsebody}
    Log    ${Result}
    ${deliveryReceiptId}    Get Json Value    ${Result}    /deliveryReceiptId
    Log    ${deliveryReceiptId}
    ${finaldeliveryReceiptId}    Remove String    ${deliveryReceiptId}    "    "
    Log    ${finaldeliveryReceiptId}
    Sleep    20s
    #################Validating the logs from mom-mock-services##############################
    ${mocklog}    get logs    ${auth_sms_sender}    ${project_id}    ${mock_service}    ${finaldeliveryReceiptId}
    Log    ${mocklog}
    ${LogResult}    Convert To String    ${mocklog}
    Should Contain    ${LogResult}    ${finaldeliveryReceiptId}
    Should Contain    ${LogResult}    ${sender_address}

Send a message directly to SMS_Semder cloud run validating Pub/Sub sent to billing
    [Tags]    smssender
    ${randomnum}    Generate Random String    22    LKWEB67841oiuy
    Log    ${randomnum}
    ${RequestBody}    Catenate    {"recipient": {"type": "PhoneNumber", "value": "1${phone_number}"}, "messageText": "MOM Test ", "trackingId": "${randomnum}", "expiration": "2021-08-16T01:28:51.977Z", "senderAddress": "${sender_address}", "received": "2020-11-10T11:00:00.452Z", "uuid": "f7852ffb-auto-test-smss-001100001111", "clientId": "${clientId}", "smsCode": "18557992233" }
    ${ResponseBody}    Sms Sender    ${sms_sender_host}    ${RequestBody}    ${sms_sender_method}
    Log    ${ResponseBody}
    Response Status Code Should Equal    200
    Response Body should Contain    SENT
    ${responsebody}    Get Response Body
    Log    ${responsebody}
    ${Result}    Convert to String    ${responsebody}
    Log    ${Result}
    ${deliveryReceiptId}    Get Json Value    ${Result}    /deliveryReceiptId
    Log    ${deliveryReceiptId}
    ${finaldeliveryReceiptId}    Remove String    ${deliveryReceiptId}    "    "
    Log    ${finaldeliveryReceiptId}
    ${subscription_message}    billing    ${auth_sms_sender}    ${project_id}    ${mt_billing_topic}    ${finaldeliveryReceiptId}
    Log    ${subscription_message}
    ${billing_topicMessage}    Convert to String    ${subscription_message}
    Should Contain    ${billing_topicMessage}    "deliveryReceiptId":"${finaldeliveryReceiptId}"
    Should Contain    ${billing_topicMessage}    "status":"SENT"
    Should Contain    ${billing_topicMessage}    "smsCode":"18557992233"
