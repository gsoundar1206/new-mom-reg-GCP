*** Settings ***
Resource          Resource_${environment}.txt
Resource          Resource.txt

*** Test Cases ***
Precondition - GENERATE BEARER TOKEN
    [Tags]    Precondition    SmokeTest    KeywordResponderAdmin
    ${Bearer}=    token    ${keyword_responder_admin_host_https}    ${auth_json}
    Log    ${Bearer}
    Set Global Variable    ${Bearer}

Precondition
    [Tags]    Precondition    KeywordResponder    SmokeTest
    ########Adding shortcode and keyword for keyword topic #################
    ${RequestBody}    Catenate    {"name":"keywordtopic", "shortCode":"${mom_keyword_shortcode}", "keywordExpression":"Shopping", "response":"I love to shop message from Ride Test","clientId":"1" }
    Log    ${RequestBody}
    ${ResponseBody}    Keyword Responder Admin    ${keyword_responder_admin_host}    ${RequestBody}    ${keyword_responder_admin_service}
    Log    ${ResponseBody}
    ${Result}    Convert to String    ${ResponseBody}
    Log    ${Result}
    Should Contain    ${Result}    200
    ###########Get a single shortcode##########
    ${response}=    Get Shortcode    ${keyword_responder_admin_host_https}    ${keyword_responder_admin_service}/${mom_keyword_shortcode}
    Log    ${response.text}
    Should Be Equal As Strings    ${response.status_code}    200
    Should Contain    ${response.text}    "name":"keywordtopic",
    Should Contain    ${response.text}    "shortCode":"${mom_keyword_shortcode}",
    Should Contain    ${response.text}    "keywordExpression":"Shopping",
    Should Contain    ${response.text}    "response":"I love to shop message from Ride Test"
    ##############Adding shortcode and keyword for paas topic #################
    ${RequestBody}    Catenate    {"name":"paastopic", "shortCode":"${mom_paas_shortcode}", "keywordExpression":"Garden", "response":"Welcome to my garden message from Ride Test","clientId":"1"}
    Log    ${RequestBody}
    ${ResponseBody}    Keyword Responder Admin    ${keyword_responder_admin_host}    ${RequestBody}    ${keyword_responder_admin_service}
    Log    ${ResponseBody}
    ${Result}    Convert to String    ${ResponseBody}
    Log    ${Result}
    Should Contain    ${Result}    200
    ###########Get a single shortcode##########
    ${response}=    Get Shortcode    ${keyword_responder_admin_host_https}    ${keyword_responder_admin_service}/${mom_paas_shortcode}
    Log    ${response.text}
    Should Be Equal As Strings    ${response.status_code}    200
    Should Contain    ${response.text}    "name":"paastopic",
    Should Contain    ${response.text}    "shortCode":"${mom_paas_shortcode}",
    Should Contain    ${response.text}    "keywordExpression":"Garden",
    Should Contain    ${response.text}    "response":"Welcome to my garden message from Ride Test"

001 Validate KeywordResponder with message_body="Shopping" for keyword topic
    [Tags]    KeywordResponder    SmokeTest
    ${time} =    Get Current Date    result_format=%Y-%m-%dT%H:%M:%S.%MZ    exclude_millis=false
    Log    ${time}
    ${randomnumber_messageid}    Generate Random String    22    PXHR12341abcd
    Log    ${randomnumber_messageid}
    ##########Using mo publisher to publish message to keyword topic##########
    ${RequestBody}    Catenate    {"topic":"SCG-Message","event":{"fld-val-list":{"sender_id_alias":"Gladiator","mo_price":0.0095,"company-id":110408,"sender_id_id":"${sender_address}","message_body":"Shopping","message_id":"${randomnumber_messageid}","to_address":"${mom_keyword_shortcode}","has_attachment":false,"fragments_count":1,"from_address":"+1${phone_number}","application_id":${app_id}}, "evt-tp":"mo_message_received","timestamp":"${time}"},"attempt":"1","event-id":"qgIwuZ9MRpCuoW9RYoTjkw"}
    Log    ${RequestBody}
    ${response}=    Mo Publisher    ${RequestBody}
    ${responseAsDict}=    Evaluate    json.loads('''${response.text}''')    modules=json
    Log    ${responseAsDict}
    Should be Equal as Strings    ${response.status_code}    200
    ${messageid}    Convert to string    ${responseAsDict}
    ${finalmessageId}=    remove string    ${messageid}    {'messageIds': ['    ']}
    Log    ${finalmessageId}
    Sleep    15 sec
    ############Checking the mo message in keyword topic#########
    ${subscription_message}    Pubsub Msg    ${auth_json}    ${project_id}    ${mo_keyword_topic}    ${finalmessageId}
    Log    ${subscription_message}
    ${keyword_topicMessage}    Convert to string    ${subscription_message}
    Log    ${keyword_topicMessage}
    Should Contain    ${keyword_topicMessage}    "from_number":"+1${phone_number}",
    Should Contain    ${keyword_topicMessage}    "to_number":"${mom_keyword_shortcode}",
    Should Contain    ${keyword_topicMessage}    "to_id":"${sender_address}",
    Should Contain    ${keyword_topicMessage}    "message_body":"Shopping",
    Should Contain    ${keyword_topicMessage}    "message_id":"${randomnumber_messageid}",
    Should Contain    ${keyword_topicMessage}    "aggregator":"${aggregator}",
    Should Contain    ${keyword_topicMessage}    "message_received_at":"${time}"
    Sleep    15 sec
    #############checking keyword reponder logs for passing through internal mt proxy (ApigeeProxyClient#sendMtMessage)########
    ${keyword_responder_log}    get keywordresponder logs    ${auth_sms_sender}    ${project_id}    mom-keyword-responder    ${randomnumber_messageid}
    Log    ${keyword_responder_log}
    ${mt_internal_proxy_statuscode}    Fetch From Right    ${keyword_responder_log}    :
    Log    ${mt_internal_proxy_statuscode}
    Should Contain    ${mt_internal_proxy_statuscode}    200 OK
    Sleep    15 sec
    ###########Checking the mo message in mo billing topic##########
    ${final_subscription_message}    Final Msg    ${auth_json}    ${project_id}    ${mo_final_billing_topic}    ${randomnumber_messageid}
    Log    ${final_subscription_message}
    ${final_topicMessage}    Convert to string    ${final_subscription_message}
    Log    ${final_topicMessage}
    Should Contain    ${final_topicMessage}    "to_number":"${mom_keyword_shortcode}"
    Should Contain    ${final_topicMessage}    "message_body":"Shopping",
    Should Contain    ${final_topicMessage}    "message_id":"${randomnumber_messageid}",
    Should Contain    ${final_topicMessage}    "from_number":"+1${phone_number}",
    Should Contain    ${final_topicMessage}    "aggregator":"${aggregator}",
    ###############Checking the mt reply message in mt sms topic#########################
    ${mt_subscription_message}    Keyword Resp    ${auth_json}    ${project_id}    ${mt-sms-subscription_topic}    ${randomnumber_messageid}
    Log    ${mt_subscription_message}
    ${MT_topicMessage}    Convert to string    ${mt_subscription_message}
    Log    ${MT_topicMessage}
    Should contain    ${MT_topicMessage}    "senderAddress":"${sender_address}"
    Should contain    ${MT_topicMessage}    "value":"+1${phone_number}",
    Should contain    ${MT_topicMessage}    "messageText":"I love to shop message from Ride Test",
    Sleep    20 sec
    #################Validating the logs from mom-sms-sender##############################
    ${smssenderlog}    get logs    ${auth_sms_sender}    ${project_id}    ${sms_sender_service}    Finished to process sendSMS
    Log    ${smssenderlog}
    ${LogResult}    Convert To String    ${smssenderlog}
    Should Contain    ${LogResult}    Finished to process sendSMS
    ###############Checking the mt reply message in mt billing topic#########################
    ${billing_subscription_message}    Keyword Resp    ${auth_json}    ${project_id}    ${mt_billing_topic}    ${randomnumber_messageid}
    Log    ${billing_subscription_message}
    ${billing_topicMessage}    Convert to string    ${billing_subscription_message}
    Log    ${billing_topicMessage}
    Should Contain    ${billing_topicMessage}    "value":"+1${phone_number}",
    Should Contain    ${billing_topicMessage}    "senderAddress":"${sender_address}",
    Should Contain    ${billing_topicMessage}    "trackingId":"parent_msg_id:${randomnumber_messageid}"
    Should Contain    ${billing_topicMessage}    "messageText":"I love to shop message from Ride Test",

002 Validate KeywordResponder with message_body="Garden" for paas topic
    [Tags]    KeywordResponder    SmokeTest
    ${time} =    Get Current Date    result_format=%Y-%m-%dT%H:%M:%S.%MZ    exclude_millis=false
    Log    ${time}
    ${randomnumber_messageid}    Generate Random String    22    PXHR12341abcd
    Log    ${randomnumber_messageid}
    ##########Using mo publisher to publish message to keyword topic##########
    ${RequestBody}    Catenate    {"topic":"SCG-Message","event":{"fld-val-list":{"sender_id_alias":"Gladiator","mo_price":0.0095,"company-id":110408,"sender_id_id":"${sender_address}","message_body":"Garden","message_id":"${randomnumber_messageid}","to_address":"${mom_paas_shortcode}","has_attachment":false,"fragments_count":1,"from_address":"+1${phone_number}","application_id":${app_id}}, "evt-tp":"mo_message_received","timestamp":"${time}"},"attempt":"1","event-id":"qgIwuZ9MRpCuoW9RYoTjkw"}
    Log    ${RequestBody}
    ${response}=    Mo Publisher    ${RequestBody}
    ${responseAsDict}=    Evaluate    json.loads('''${response.text}''')    modules=json
    Log    ${responseAsDict}
    Should be Equal as Strings    ${response.status_code}    200
    ${messageid}    Convert to string    ${responseAsDict}
    ${finalmessageId}=    remove string    ${messageid}    {'messageIds': ['    ']}
    Log    ${finalmessageId}
    Sleep    15 sec
    ############Checking the mo message in paas topic#########
    ${subscription_message}    Pubsub Msg    ${auth_json}    ${project_id}    ${mo_paas_topic}    ${finalmessageId}
    Log    ${subscription_message}
    ${keyword_topicMessage}    Convert to string    ${subscription_message}
    Log    ${keyword_topicMessage}
    Should Contain    ${keyword_topicMessage}    "from_number":"+1${phone_number}",
    Should Contain    ${keyword_topicMessage}    "to_number":"${mom_paas_shortcode}",
    Should Contain    ${keyword_topicMessage}    "to_id":"${sender_address}",
    Should Contain    ${keyword_topicMessage}    "message_body":"Garden",
    Should Contain    ${keyword_topicMessage}    "message_id":"${randomnumber_messageid}",
    Should Contain    ${keyword_topicMessage}    "aggregator":"${aggregator}",
    Should Contain    ${keyword_topicMessage}    "message_received_at":"${time}"
    #########MT messages will ultimately end up at the client################

003 Validate KeywordResponder with message_body="Leaf" to generate Default mt message
    [Tags]    KeywordResponder
    ${time} =    Get Current Date    result_format=%Y-%m-%dT%H:%M:%S.%MZ    exclude_millis=false
    Log    ${time}
    ${randomnumber_messageid}    Generate Random String    22    MKJHG12341abcd
    Log    ${randomnumber_messageid}
    ##########Using mo publisher to publish message to keyword topic##########
    ${RequestBody}    Catenate    {"topic":"SCG-Message","event":{"fld-val-list":{"sender_id_alias":"Gladiator","mo_price":0.0095,"company-id":110408,"sender_id_id":"${sender_address}","message_body":"Leaf","message_id":"${randomnumber_messageid}","to_address":"${mom_keyword_shortcode}","has_attachment":false,"fragments_count":1,"from_address":"+1${phone_number}","application_id":${app_id}}, "evt-tp":"mo_message_received","timestamp":"${time}"},"attempt":"1","event-id":"qgIwuZ9MRpCuoW9RYoTjkw"}
    Log    ${RequestBody}
    ${response}=    Mo Publisher    ${RequestBody}
    ${responseAsDict}=    Evaluate    json.loads('''${response.text}''')    modules=json
    Log    ${responseAsDict}
    Should be Equal as Strings    ${response.status_code}    200
    ${messageid}    Convert to string    ${responseAsDict}
    ${finalmessageId}=    remove string    ${messageid}    {'messageIds': ['    ']}
    Log    ${finalmessageId}
    Sleep    15 sec
    ############Checking the mo message in keyword topic#########
    ${subscription_message}    Pubsub Msg    ${auth_json}    ${project_id}    ${mo_keyword_topic}    ${finalmessageId}
    Log    ${subscription_message}
    ${keyword_topicMessage}    Convert to string    ${subscription_message}
    Log    ${keyword_topicMessage}
    Should Contain    ${keyword_topicMessage}    "to_number":"${mom_keyword_shortcode}"
    Should Contain    ${keyword_topicMessage}    "message_body":"Leaf",
    Should Contain    ${keyword_topicMessage}    "message_id":"${randomnumber_messageid}",
    Should Contain    ${keyword_topicMessage}    "from_number":"+1${phone_number}",
    Should Contain    ${keyword_topicMessage}    "to_id":"${sender_address}",
    Should Contain    ${keyword_topicMessage}    "aggregator":"${aggregator}",
    Should Contain    ${keyword_topicMessage}    "message_received_at":"${time}"
    Sleep    15 sec
    #############checking keyword reponder logs for passing through internal mt proxy (ApigeeProxyClient#sendMtMessage)########
    ${keyword_responder_log}    get keywordresponder logs    ${auth_sms_sender}    ${project_id}    mom-keyword-responder    ${randomnumber_messageid}
    Log    ${keyword_responder_log}
    ${mt_internal_proxy_statuscode}    Fetch From Right    ${keyword_responder_log}    :
    Log    ${mt_internal_proxy_statuscode}
    Should Contain    ${mt_internal_proxy_statuscode}    200 OK
    Sleep    15 sec
    ###############Checking the mo message in mo final billing topic#########################
    ${final_subscription_message}    Final Msg    ${auth_json}    ${project_id}    ${mo_final_billing_topic}    ${randomnumber_messageid}
    Log    ${final_subscription_message}
    ${final_topicMessage}    Convert to string    ${final_subscription_message}
    Log    ${final_topicMessage}
    Should Contain    ${final_topicMessage}    "to_number":"${mom_keyword_shortcode}"
    Should Contain    ${final_topicMessage}    "message_body":"Leaf"
    Should Contain    ${final_topicMessage}    "message_id":"${randomnumber_messageid}",
    Should Contain    ${final_topicMessage}    "from_number":"+1${phone_number}",
    Should Contain    ${final_topicMessage}    "aggregator":"${aggregator}",
    Sleep    20 sec
    #################Validating the logs from mom-sms-sender##############################
    ${smssenderlog}    get logs    ${auth_sms_sender}    ${project_id}    ${sms_sender_service}    Finished to process sendSMS
    Log    ${smssenderlog}
    ${LogResult}    Convert To String    ${smssenderlog}
    Should Contain    ${LogResult}    Finished to process sendSMS
    ###############Checking the mt reply message in mt sms topic#########################
    ${mt_subscription_message}    Keyword Resp    ${auth_json}    ${project_id}    ${mt-sms-subscription_topic}    ${randomnumber_messageid}
    Log    ${mt_subscription_message}
    ${MT_topicMessage}    Convert to string    ${mt_subscription_message}
    Log    ${MT_topicMessage}
    Should contain    ${MT_topicMessage}    "senderAddress":"${sender_address}"
    Should contain    ${MT_topicMessage}    "value":"+1${phone_number}",
    Should contain    ${MT_topicMessage}    "messageText":"Welcome to MOM Platform default test message",
    ###############Checking the mt reply message in mt billing topic#########################
    ${billing_subscription_message}    Keyword Resp    ${auth_json}    ${project_id}    ${mt_billing_topic}    ${randomnumber_messageid}
    Log    ${billing_subscription_message}
    ${billing_topicMessage}    Convert to string    ${billing_subscription_message}
    Log    ${billing_topicMessage}
    Should Contain    ${billing_topicMessage}    "value":"+1${phone_number}",
    Should Contain    ${billing_topicMessage}    "senderAddress":"${sender_address}",
    Should Contain    ${billing_topicMessage}    "trackingId":"parent_msg_id:${randomnumber_messageid}"
    Should Contain    ${billing_topicMessage}    "messageText":"Welcome to MOM Platform default test message",

004 Validate KeywordResponder with message_body="Garden" shortcode doesn't exits and message goes through Paas Topic
    [Tags]    KeywordResponder
    ${time} =    Get Current Date    result_format=%Y-%m-%dT%H:%M:%S.%MZ    exclude_millis=false
    Log    ${time}
    ${randomnumber_messageid}    Generate Random String    22    PXHR12341abcd
    Log    ${randomnumber_messageid}
    ${RequestBody}    Catenate    {"topic":"SCG-Message","event":{"fld-val-list":{"sender_id_alias":"Gladiator","mo_price":0.0095,"company-id":110408,"sender_id_id":"${sender_address}","message_body":"Garden","message_id":"${randomnumber_messageid}","to_address":"${non_existing_shortcode}","has_attachment":false,"fragments_count":1,"from_address":"+1${phone_number}","application_id":${app_id}}, "evt-tp":"mo_message_received","timestamp":"${time}"},"attempt":"1","event-id":"qgIwuZ9MRpCuoW9RYoTjkw"}
    ${response}=    Mo Publisher    ${RequestBody}
    ${responseAsDict}=    Evaluate    json.loads('''${response.text}''')    modules=json
    Log    ${responseAsDict}
    Should be Equal as Strings    ${response.status_code}    200
    ${messageid}    Convert to string    ${responseAsDict}
    ${finalmessageId}=    remove string    ${messageid}    {'messageIds': ['    ']}
    Log    ${finalmessageId}
    Sleep    15 sec
    ############Checking the mo message in paas topic#########
    ${subscription_message}    Pubsub Msg    ${auth_json}    ${project_id}    ${mo_paas_topic}    ${finalmessageId}
    Log    ${subscription_message}
    ${keyword_topicMessage}    Convert to string    ${subscription_message}
    Log    ${keyword_topicMessage}
    Should Contain    ${keyword_topicMessage}    "to_number":"${non_existing_shortcode}"
    Should Contain    ${keyword_topicMessage}    "message_body":"Garden",
    Should Contain    ${keyword_topicMessage}    "message_id":"${randomnumber_messageid}",
    Should Contain    ${keyword_topicMessage}    "from_number":"+1${phone_number}",
    Should Contain    ${keyword_topicMessage}    "to_id":"${sender_address}",
    Should Contain    ${keyword_topicMessage}    "aggregator":"${aggregator}",
    Should Contain    ${keyword_topicMessage}    "message_received_at":"${time}"

Postcondition
    [Tags]    Postcondition    KeywordResponder    SmokeTest
    ########### Delete shortcode ##########
    ${response}=    Delete Shortcode    ${keyword_responder_admin_host_https}    ${keyword_responder_admin_service}/${mom_keyword_shortcode}/keywordtopic
    Log    ${response.text}
    ${response}=    Delete Shortcode    ${keyword_responder_admin_host_https}    ${keyword_responder_admin_service}/${mom_paas_shortcode}/paastopic
    Log    ${response.text}
