*** Settings ***
Resource          Resource.txt
Resource          Resource_${environment}.txt

*** Test Cases ***
001 Publishing a message to Pub/Sub Topic mom-mo-message and Validate Pub/Sub sent to billing for API key Authentication
    [Tags]    SmokeTest    morouter
    ${time} =    Get Current Date    result_format=%Y-%m-%dT%H:%M:%S.%MZ    exclude_millis=false
    Log    ${time}
    ${randomnum}    Generate Random String    22    RPDFG12341gnxz
    Log    ${randomnum}
    ${RequestBody}    Catenate    {"scg_message":"{\\"topic\\":\\"SCG-Message\\",\\"event\\":{\\"fld-val-list\\":{\\"sender_id_alias\\":\\"Gladiator\\",\\"mo_price\\":0.0095,\\"company-id\\":110408,\\"sender_id_id\\":\\"${sender_address}\\",\\"message_body\\":\\"Help\\",\\"message_id\\":\\"${randomnum}\\",\\"to_address\\":\\"${mo_router_shortcode_apikey}\\",\\"has_attachment\\":false,\\"fragments_count\\":1,\\"from_address\\":\\"+1${phone_number}\\",\\"application_id\\":${app_id}}, \\"evt-tp\\":\\"mo_message_received\\",\\"timestamp\\":\\"${time}\\"},\\"attempt\\":\\"1\\",\\"event-id\\":\\"qgIwuZ9MRpCuoW9RYoTjkw\\"}","mom_proxy_received_time":"${time}","message_id":"${randomnum}","from_number":"+1${phone_number}","to_number":${mo_router_shortcode_apikey},"to_id":"${sender_address}","message_body":"Help","message_received_at":"${time}","aggregator":"Syniverse"}
    ${Result}    publish    ${auth_sms_sender}    ${project_id}    ${morouter_subscription_topic}    ${RequestBody}
    ${FinalResult}    Final Msg    ${auth_json}    ${project_id}    ${mo_final_billing_topic}    ${randomnum}
    Log    ${FinalResult}
    Should Contain    ${FinalResult}    "message_id":"${randomnum}"
    Should Contain Any    ${FinalResult}    \\"attempt\\":\\"1\\"    \\"attempt\\":"\\2\\"    \\"attempt\\":"\\3\\"    \\"attempt\\":\\"4\\"    \\"attempt\\":"\\5\\"
    Should Contain    ${FinalResult}    "message_body":"Help",
    Should Contain    ${FinalResult}    "mom_postback_status":"SUCCESS"
    Should Contain    ${FinalResult}    "mom_postback_error_info":"200.OK.Success."
    Should Contain    ${FinalResult}    "mom_postback_url":"${mom_postback_url}",

DNR- 002 Publishing a message to Pub/Sub Topic mom-mo-message and Validate Pub/Sub sent to billing for OAuth Authentication
    [Tags]    DoNotRun    SmokeTest    morouter
    ${time} =    Get Current Date    result_format=%Y-%m-%dT%H:%M:%S.%MZ    exclude_millis=false
    Log    ${time}
    ${randomnum}    Generate Random String    22    RPDFG12341gnxz
    Log    ${randomnum}
    ${RequestBody}    Catenate    {"scg_message":"{\\"topic\\":\\"SCG-Message\\",\\"event\\":{\\"fld-val-list\\":{\\"sender_id_alias\\":\\"Gladiator\\",\\"mo_price\\":0.0095,\\"company-id\\":110408,\\"sender_id_id\\":\\"${sender_address}\\",\\"message_body\\":\\"Help\\",\\"message_id\\":\\"${randomnum}\\",\\"to_address\\":\\"${mo_router_shortcode_oAuth}\\",\\"has_attachment\\":false,\\"fragments_count\\":1,\\"from_address\\":\\"+1${phone_number}\\",\\"application_id\\":6946}, \\"evt-tp\\":\\"mo_message_received\\",\\"timestamp\\":\\"${time}\\"},\\"attempt\\":\\"1\\",\\"event-id\\":\\"qgIwuZ9MRpCuoW9RYoTjkw\\"}","mom_proxy_received_time":"${time}","message_id":"${randomnum}","from_number":"+1${phone_number}","to_number":${mo_router_shortcode_oAuth},"to_id":"${sender_address}","message_body":"Help","message_received_at":"${time}","aggregator":"Syniverse"}
    ${Result}    publish    ${auth_sms_sender}    ${project_id}    ${morouter_subscription_topic}    ${RequestBody}
    ${FinalResult}    Final Msg    ${auth_sms_sender}    ${project_id}    ${mo_final_billing_topic}    ${randomnum}
    Log    ${FinalResult}
    Should Contain    ${FinalResult}    "message_id":"${randomnum}"
    Should Contain Any    ${FinalResult}    \\"attempt\\":\\"1\\"    \\"attempt\\":"\\2\\"    \\"attempt\\":"\\3\\"    \\"attempt\\":\\"4\\"    \\"attempt\\":"\\5\\"
    Should Contain    ${FinalResult}    "message_body":"Help",
    Should Contain    ${FinalResult}    "mom_postback_status":"SUCCESS"
    Should Contain    ${FinalResult}    "mom_postback_error_info":"200.OK.Success."
    Should Contain    ${FinalResult}    "mom_postback_url":"${mom_postback_url}",

DNR- 003 Publishing a message to Pub/Sub Topic mom-mo-message and Validate Pub/Sub sent to billing for JWT Authentication
    [Tags]    DoNotRun    morouter
    ${time} =    Get Current Date    result_format=%Y-%m-%dT%H:%M:%S.%MZ    exclude_millis=false
    Log    ${time}
    ${randomnum}    Generate Random String    22    RPDFG12341gnxz
    Log    ${randomnum}
    ${RequestBody}    Catenate    {"scg_message":"{\\"topic\\":\\"SCG-Message\\",\\"event\\":{\\"fld-val-list\\":{\\"sender_id_alias\\":\\"Gladiator\\",\\"mo_price\\":0.0095,\\"company-id\\":110408,\\"sender_id_id\\":\\"${sender_address}\\",\\"message_body\\":\\"Help\\",\\"message_id\\":\\"${randomnum}\\",\\"to_address\\":\\"${mo_router_shortcode_JWT}\\",\\"has_attachment\\":false,\\"fragments_count\\":1,\\"from_address\\":\\"+1${phone_number}\\",\\"application_id\\":6946}, \\"evt-tp\\":\\"mo_message_received\\",\\"timestamp\\":\\"${time}\\"},\\"attempt\\":\\"1\\",\\"event-id\\":\\"qgIwuZ9MRpCuoW9RYoTjkw\\"}","mom_proxy_received_time":"${time}","message_id":"${randomnum}","from_number":"+1${phone_number}","to_number":${mo_router_shortcode_JWT},"to_id":"${sender_address}","message_body":"Help","message_received_at":"${time}","aggregator":"Syniverse"}
    ${Result}    publish    ${auth_sms_sender}    ${project_id}    ${morouter_subscription_topic}    ${RequestBody}
    ${FinalResult}    Final Msg    ${auth_sms_sender}    ${project_id}    ${mo_final_billing_topic}    ${randomnum}
    Log    ${FinalResult}
    Should Contain    ${FinalResult}    "message_id":"${randomnum}"
    Should Contain Any    ${FinalResult}    \\"attempt\\":\\"1\\"    \\"attempt\\":"\\2\\"    \\"attempt\\":"\\3\\"    \\"attempt\\":\\"4\\"    \\"attempt\\":"\\5\\"
    Should Contain    ${FinalResult}    "message_body":"Help",
    Should Contain    ${FinalResult}    "mom_postback_status":"SUCCESS"
    Should Contain    ${FinalResult}    "mom_postback_error_info":"200.OK.Success."
    Should Contain    ${FinalResult}    "mom_postback_url":"${mom_postback_url}",

DNR- 004 Publishing a message to Pub/Sub Topic mom-mo-message and Validate Pub/Sub sent to billing for 1 way SSL Authentication
    [Tags]    DoNotRun    morouter
    ${time} =    Get Current Date    result_format=%Y-%m-%dT%H:%M:%S.%MZ    exclude_millis=false
    Log    ${time}
    ${randomnum}    Generate Random String    22    RPDFG12341gnxz
    Log    ${randomnum}
    ${RequestBody}    Catenate    {"scg_message":"{\\"topic\\":\\"SCG-Message\\",\\"event\\":{\\"fld-val-list\\":{\\"sender_id_alias\\":\\"Gladiator\\",\\"mo_price\\":0.0095,\\"company-id\\":110408,\\"sender_id_id\\":\\"${sender_address}\\",\\"message_body\\":\\"Help\\",\\"message_id\\":\\"${randomnum}\\",\\"to_address\\":\\"${mo_router_shortcode_1wayssl}\\",\\"has_attachment\\":false,\\"fragments_count\\":1,\\"from_address\\":\\"+1${phone_number}\\",\\"application_id\\":6946}, \\"evt-tp\\":\\"mo_message_received\\",\\"timestamp\\":\\"${time}\\"},\\"attempt\\":\\"1\\",\\"event-id\\":\\"qgIwuZ9MRpCuoW9RYoTjkw\\"}","mom_proxy_received_time":"${time}","message_id":"${randomnum}","from_number":"+1${phone_number}","to_number":${mo_router_shortcode_1wayssl},"to_id":"${sender_address}","message_body":"Help","message_received_at":"${time}","aggregator":"Syniverse"}
    ${Result}    publish    ${auth_sms_sender}    ${project_id}    ${morouter_subscription_topic}    ${RequestBody}
    ${FinalResult}    Final Msg    ${auth_sms_sender}    ${project_id}    ${mo_final_billing_topic}    ${randomnum}
    Log    ${FinalResult}
    Should Contain    ${FinalResult}    "message_id":"${randomnum}"
    Should Contain Any    ${FinalResult}    \\"attempt\\":\\"1\\"    \\"attempt\\":"\\2\\"    \\"attempt\\":"\\3\\"    \\"attempt\\":\\"4\\"    \\"attempt\\":"\\5\\"
    Should Contain    ${FinalResult}    "message_body":"Help",
    Should Contain    ${FinalResult}    "mom_postback_status":"SUCCESS"
    Should Contain    ${FinalResult}    "mom_postback_error_info":"200.OK.Success."
    Should Contain    ${FinalResult}    "mom_postback_url":"${mom_postback_url}",

DNR- 005 Publishing a message to Pub/Sub Topic mom-mo-message and Validate Pub/Sub sent to billing for 2 way SSL Authentication
    [Tags]    DoNotRun    morouter
    ${time} =    Get Current Date    result_format=%Y-%m-%dT%H:%M:%S.%MZ    exclude_millis=false
    Log    ${time}
    ${randomnum}    Generate Random String    22    RPDFG12341gnxz
    Log    ${randomnum}
    ${RequestBody}    Catenate    {"scg_message":"{\\"topic\\":\\"SCG-Message\\",\\"event\\":{\\"fld-val-list\\":{\\"sender_id_alias\\":\\"Gladiator\\",\\"mo_price\\":0.0095,\\"company-id\\":110408,\\"sender_id_id\\":\\"${sender_address}\\",\\"message_body\\":\\"Help\\",\\"message_id\\":\\"${randomnum}\\",\\"to_address\\":\\"shortcode9\\",\\"has_attachment\\":false,\\"fragments_count\\":1,\\"from_address\\":\\"+1${phone_number}\\",\\"application_id\\":6946}, \\"evt-tp\\":\\"mo_message_received\\",\\"timestamp\\":\\"${time}\\"},\\"attempt\\":\\"1\\",\\"event-id\\":\\"qgIwuZ9MRpCuoW9RYoTjkw\\"}","mom_proxy_received_time":"${time}","message_id":"${randomnum}","from_number":"+1${phone_number}","to_number":shortcode9,"to_id":"${sender_address}","message_body":"Help","message_received_at":"${time}","aggregator":"Syniverse"}
    ${Result}    publish    ${auth_sms_sender}    ${project_id}    ${morouter_subscription_topic}    ${RequestBody}
    ${FinalResult}    Final Msg    ${auth_sms_sender}    ${project_id}    ${mo_final_billing_topic}    ${randomnum}
    Log    ${FinalResult}
    Should Contain    ${FinalResult}    "message_id":"${randomnum}"
    Should Contain Any    ${FinalResult}    \\"attempt\\":\\"1\\"    \\"attempt\\":"\\2\\"    \\"attempt\\":"\\3\\"    \\"attempt\\":\\"4\\"    \\"attempt\\":"\\5\\"
    Should Contain    ${FinalResult}    "message_body":"Help",
    Should Contain    ${FinalResult}    "mom_postback_status":"SUCCESS"
    Should Contain    ${FinalResult}    "mom_postback_error_info":"200.OK.Success."
    Should Contain    ${FinalResult}    "mom_postback_url":"${mom_postback_url}",
    ########## Only adding API key and OAUTH Authentication with base 64 as the test cases will become redundent    ############

DNR- 006 Publishing a message to the MO Router using a base64 encoded body
    [Tags]    DoNotRun    TemplateForBase64
    ${time} =    Get Current Date    result_format=%Y-%m-%dT%H:%M:%S.%MZ    exclude_millis=false
    Log    ${time}
    ${randomnum}    Generate Random String    22    DRASM12341rtyh
    Log    ${randomnum}
    ${RequestBody}    Catenate    {"deliveryAttempt":1,"message":{"data":"ewoic2NnX21lc3NhZ2UiOgp7InRvcGljIjoiU0NHLU1lc3NhZ2UiLCJldmVudCI6eyJmbGQtdmFsLWxpc3QiOnsic2VuZGVyX2lkX2FsaWFzIjoiR2xhZGlhdG9yIiwKIm1vX3ByaWNlIjowLjAwOTUsImNvbXBhbnlpZCI6MTEwNDA4LCJzZW5kZXJfaWRfaWQiOiJGeTRkYjFiZDRSRTlBNjY1SmpZNHY2IiwibWVzc2FnZV9ib2R5IjoiSGVscCIsIm1lc3NhZ2VfaWQiOiJ6VGZxeE4wUktTbjN5S1l5a2pJYlAxIiwKInRvX2FkZHJlc3MiOiJzaG9ydGNvZGUyIiwKImhhc19hdHRhY2htZW50IjpmYWxzZSwiZnJhZ21lbnRzX2NvdW50IjoxLCJmcm9tX2FkZHJlc3MiOiIrMTQwMjMwNTk5NTkiLCJhcHBsaWNhdGlvbl9pZCI6Njk0Nn0sImV2dC10cCI6Im1vX21lc3NhZ2VfcmVjZWl2ZWQiLCJ0aW1lc3RhbXAiOiIyMDIwLTA5LTI4VDIwOjI1OjUwLjc3NFoifSwiYXR0ZW1wdCI6IjEiLCJldmVudC1pZCI6InFnSXd1WjlNUnBDdW9XOVJZb1Rqa3cifSwKIm1vbV9wcm94eV9yZWNlaXZlZF90aW1lIjoiMjAyMC0wMS0wNlQwMDowMDowMC4wMDBaIgp9"}}
    Log    ${RequestBody}
    ${ResponseBody}    MO Router    ${mo_router_host}    ${RequestBody}    ${mo_router_method}
    Log    ${ResponseBody}
    Response Status Code Should Equal    200
    Response Body should Contain    Success

007 Publishing a message to the MO Router using a base64 encoded body using API Key Authentication
    [Tags]    SmokeTest    morouter
    ${time} =    Get Current Date    result_format=%Y-%m-%dT%H:%M:%S.%MZ    exclude_millis=false
    Log    ${time}
    ${randomnum}    Generate Random String    22    DRASM12341rtyh
    Log    ${randomnum}
    ${RequestBody}    Catenate    {"scg_message":"{\\"topic\\":\\"SCG-Message\\",\\"event\\":{\\"fld-val-list\\":{\\"sender_id_alias\\":\\"Gladiator\\",\\"mo_price\\":0.0095,\\"company-id\\":110408,\\"sender_id_id\\":\\"${sender_address}\\",\\"message_body\\":\\"Help\\",\\"message_id\\":\\"${randomnum}\\",\\"to_address\\":\\"${mo_router_shortcode_apikey}\\",\\"has_attachment\\":false,\\"fragments_count\\":1,\\"from_address\\":\\"+1${phone_number}\\",\\"application_id\\":${app_id}}, \\"evt-tp\\":\\"mo_message_received\\",\\"timestamp\\":\\"${time}\\"},\\"attempt\\":\\"1\\",\\"event-id\\":\\"qgIwuZ9MRpCuoW9RYoTjkw\\"}","mom_proxy_received_time":"${time}","message_id":"${randomnum}","from_number":"+1${phone_number}","to_number":${mo_router_shortcode_apikey},"to_id":"${sender_address}","message_body":"Help","message_received_at":"${time}","aggregator":"Syniverse"}
    ${RequestBodyEncoded}=    encodetobase64    ${RequestBody}
    Log    ${RequestBodyEncoded}
    ${RequestBody}    Catenate    {"deliveryAttempt": 5,"message": {"messageId": "VwMrIQ3eEUVHl6H2nlj6M2","data": "${RequestBodyEncoded}"}}
    Log    ${RequestBody}
    ${ResponseBody}    MO Router    ${mo_router_host}    ${RequestBody}    ${mo_router_method}
    Log    ${ResponseBody}
    Response Status Code Should Equal    200
    Response Body should Contain    Success
    ${FinalResult}    Final Msg    ${auth_json}    ${project_id}    ${mo_final_billing_topic}    ${randomnum}
    Log    ${FinalResult}
    Should Contain    ${FinalResult}    "message_id":"${randomnum}"
    Should Contain Any    ${FinalResult}    \\"attempt\\":\\"1\\"    \\"attempt\\":"\\2\\"    \\"attempt\\":"\\3\\"    \\"attempt\\":\\"4\\"    \\"attempt\\":"\\5\\"
    Should Contain    ${FinalResult}    "message_body":"Help",
    Should Contain    ${FinalResult}    "mom_postback_status":"SUCCESS"
    Should Contain    ${FinalResult}    "mom_postback_error_info":"200.OK.Success."
    Should Contain    ${FinalResult}    "mom_postback_url":"${mom_postback_url}",

DNR- 008 Publishing a message to the MO Router using a base64 encoded body using OAUTH Authentication
    [Tags]    DoNotRun    SmokeTest    morouter
    ${time} =    Get Current Date    result_format=%Y-%m-%dT%H:%M:%S.%MZ    exclude_millis=false
    Log    ${time}
    ${randomnum}    Generate Random String    22    DRASM12341rtyh
    Log    ${randomnum}
    ${RequestBody}    Catenate    {"scg_message":"{\\"topic\\":\\"SCG-Message\\",\\"event\\":{\\"fld-val-list\\":{\\"sender_id_alias\\":\\"Gladiator\\",\\"mo_price\\":0.0095,\\"company-id\\":110408,\\"sender_id_id\\":\\"${sender_address}\\",\\"message_body\\":\\"Help\\",\\"message_id\\":\\"${randomnum}\\",\\"to_address\\":\\"${mo_router_shortcode_oAuth}\\",\\"has_attachment\\":false,\\"fragments_count\\":1,\\"from_address\\":\\"+1${phone_number}\\",\\"application_id\\":${app_id}}, \\"evt-tp\\":\\"mo_message_received\\",\\"timestamp\\":\\"${time}\\"},\\"attempt\\":\\"1\\",\\"event-id\\":\\"qgIwuZ9MRpCuoW9RYoTjkw\\"}","mom_proxy_received_time":"${time}","message_id":"${randomnum}","from_number":"+1${phone_number}","to_number":${mo_router_shortcode_oAuth},"to_id":"${sender_address}","message_body":"Help","message_received_at":"${time}","aggregator":"Syniverse"}
    ${RequestBodyEncoded}=    encodetobase64    ${RequestBody}
    Log    ${RequestBodyEncoded}
    ${RequestBody}    Catenate    {"deliveryAttempt": 5,"message": {"messageId": "VwMrIQ3eEUVHl6H2nlj6M2","data": "${RequestBodyEncoded}"}}
    Log    ${RequestBody}
    ${ResponseBody}    MO Router    ${mo_router_host}    ${RequestBody}    ${mo_router_method}
    Log    ${ResponseBody}
    Response Status Code Should Equal    200
    Response Body should Contain    Success
    ${FinalResult}    Final Msg    ${auth_json}    ${project_id}    ${mo_final_billing_topic}    ${randomnum}
    Log    ${FinalResult}
    Should Contain    ${FinalResult}    "message_id":"${randomnum}"
    Should Contain Any    ${FinalResult}    \\"attempt\\":\\"1\\"    \\"attempt\\":"\\2\\"    \\"attempt\\":"\\3\\"    \\"attempt\\":\\"4\\"    \\"attempt\\":"\\5\\"
    Should Contain    ${FinalResult}    "message_body":"Help",
    Should Contain    ${FinalResult}    "mom_postback_status":"SUCCESS"
    Should Contain    ${FinalResult}    "mom_postback_error_info":"200.OK.Success."
    Should Contain    ${FinalResult}    "mom_postback_url":"${mom_postback_url}",
    ############################# Negetive cases ##############################

009 Publishing a message to Pub/Sub Topic mom-mo-message with an non existing shortcode OAuth Authentication
    [Tags]    SmokeTest    morouter
    ${time} =    Get Current Date    result_format=%Y-%m-%dT%H:%M:%S.%MZ    exclude_millis=false
    Log    ${time}
    ${randomnum}    Generate Random String    22    RPDFG12341gnxz
    Log    ${randomnum}
    ${RequestBody}    Catenate    {"scg_message":"{\\"topic\\":\\"SCG-Message\\",\\"event\\":{\\"fld-val-list\\":{\\"sender_id_alias\\":\\"Gladiator\\",\\"mo_price\\":0.0095,\\"company-id\\":110408,\\"sender_id_id\\":\\"${sender_address}\\",\\"message_body\\":\\"Help\\",\\"message_id\\":\\"${randomnum}\\",\\"to_address\\":\\"${non_existing_shortcode}\\",\\"has_attachment\\":false,\\"fragments_count\\":1,\\"from_address\\":\\"+1${phone_number}\\",\\"application_id\\":${app_id}}, \\"evt-tp\\":\\"mo_message_received\\",\\"timestamp\\":\\"${time}\\"},\\"attempt\\":\\"1\\",\\"event-id\\":\\"qgIwuZ9MRpCuoW9RYoTjkw\\"}","mom_proxy_received_time":"${time}","message_id":"${randomnum}","from_number":"+1${phone_number}","to_number":${non_existing_shortcode},"to_id":"${sender_address}","message_body":"Help","message_received_at":"${time}","aggregator":"Syniverse"}
    ${Result}    publish    ${auth_sms_sender}    ${project_id}    ${morouter_subscription_topic}    ${RequestBody}
    ${FinalResult}    Final Msg    ${auth_json}    ${project_id}    ${mo_final_billing_topic}    ${randomnum}
    Log    ${FinalResult}
    Should Not Contain    ${FinalResult}    "message_id":"${randomnum}"
    #Should Contain Any    ${FinalResult}    \\"attempt\\":\\"1\\"    \\"attempt\\":"\\2\\"    \\"attempt\\":"\\3\\"    \\"attempt\\":\\"4\\"    \\"attempt\\":"\\5\\"
    #Should Contain    ${FinalResult}    "mom_postback_status":"SMSCODE_NOT_FOUND"
    #Should Contain    ${FinalResult}    "mom_postback_error_info":"Sms Code not found."

010 Publishing a message to the MO Router using a base64 encoded with an non existing shortcode OAuth Authentication
    [Tags]    SmokeTest    morouter
    ${time} =    Get Current Date    result_format=%Y-%m-%dT%H:%M:%S.%MZ    exclude_millis=false
    Log    ${time}
    ${randomnum}    Generate Random String    22    DRASM12341rtyh
    Log    ${randomnum}
    ${RequestBody}    Catenate    {"scg_message":"{\\"topic\\":\\"SCG-Message\\",\\"event\\":{\\"fld-val-list\\":{\\"sender_id_alias\\":\\"Gladiator\\",\\"mo_price\\":0.0095,\\"company-id\\":110408,\\"sender_id_id\\":\\"${sender_address}\\",\\"message_body\\":\\"Help\\",\\"message_id\\":\\"${randomnum}\\",\\"to_address\\":\\"${non_existing_shortcode}\\",\\"has_attachment\\":false,\\"fragments_count\\":1,\\"from_address\\":\\"+1${phone_number}\\",\\"application_id\\":${app_id}}, \\"evt-tp\\":\\"mo_message_received\\",\\"timestamp\\":\\"${time}\\"},\\"attempt\\":\\"1\\",\\"event-id\\":\\"qgIwuZ9MRpCuoW9RYoTjkw\\"}","mom_proxy_received_time":"${time}","message_id":"${randomnum}","from_number":"+1${phone_number}","to_number":${non_existing_shortcode},"to_id":"${sender_address}","message_body":"Help","message_received_at":"${time}","aggregator":"Syniverse"}
    ${RequestBodyEncoded}=    encodetobase64    ${RequestBody}
    Log    ${RequestBodyEncoded}
    ${RequestBody}    Catenate    {"deliveryAttempt": 5,"message": {"messageId": "VwMrIQ3eEUVHl6H2nlj6M2","data":"${RequestBodyEncoded}"}}
    Log    ${RequestBody}
    ${ResponseBody}    MO Router    ${mo_router_host}    ${RequestBody}    ${mo_router_method}
    Log    ${ResponseBody}
    Response Status Code Should Equal    503 Service Unavailable
    Response Body should Contain    The Service is temporarily unavailable

011 Publishing a message to the MO Router using a base64 encoded with an NULL applicationid OAuth Authentication
    [Tags]    SmokeTest    morouter
    ${time} =    Get Current Date    result_format=%Y-%m-%dT%H:%M:%S.%MZ    exclude_millis=false
    Log    ${time}
    ${randomnum}    Generate Random String    22    DRASM12341rtyh
    Log    ${randomnum}
    ${RequestBody}    Catenate    {"scg_message":"{\\"topic\\":\\"SCG-Message\\",\\"event\\":{\\"fld-val-list\\":{\\"sender_id_alias\\":\\"Gladiator\\",\\"mo_price\\":0.0095,\\"company-id\\":110408,\\"sender_id_id\\":\\"${sender_address}\\",\\"message_body\\":\\"Help\\",\\"message_id\\":\\"${randomnum}\\",\\"to_address\\":\\"${non_existing_shortcode}\\",\\"has_attachment\\":false,\\"fragments_count\\":1,\\"from_address\\":\\"+1${phone_number}\\",\\"application_id\\":}, \\"evt-tp\\":\\"mo_message_received\\",\\"timestamp\\":\\"${time}\\"},\\"attempt\\":\\"1\\",\\"event-id\\":\\"qgIwuZ9MRpCuoW9RYoTjkw\\"}","mom_proxy_received_time":"${time}","message_id":"${randomnum}","from_number":"+1${phone_number}","to_number":${non_existing_shortcode},"to_id":"${sender_address}","message_body":"Help","message_received_at":"${time}","aggregator":"Syniverse"}
    ${RequestBodyEncoded}=    encodetobase64    ${RequestBody}
    Log    ${RequestBodyEncoded}
    ${RequestBody}    Catenate    {"deliveryAttempt": 5,"message": {"messageId": "VwMrIQ3eEUVHl6H2nlj6M2","data":"${RequestBodyEncoded}"}}
    Log    ${RequestBody}
    ${ResponseBody}    MO Router    ${mo_router_host}    ${RequestBody}    ${mo_router_method}
    Log    ${ResponseBody}
    Response Status Code Should Equal    503 Service Unavailable
    Response Body should Contain    The Service is temporarily unavailable
