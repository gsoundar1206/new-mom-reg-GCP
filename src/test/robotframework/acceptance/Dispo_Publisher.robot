*** Settings ***
Resource          Resource_${environment}.txt
Resource          Resource.txt

*** Test Cases ***
001 Validate publishing a message from apigee to mom_dispo_publisher topic
    [Tags]    DispoPublisher    SmokeTest
    ${randomnum}    Generate Random String    22    WQSPV67548kjmc
    Log    ${randomnum}
    ${RequestBody}    Catenate    {"topic":"SCG-Message", "attempt":1, "event":{"fld-val-list":{"previous_state":"QUEUED", "message_request_id":"QlrNeo2cxytluN4mwejKd7", "message_id":"${randomnum}", "to_address":"+${phone_number}", "has_attachment":false, "reason_description":"SUCCESS", "application_id":${app_id}, "reason_code":"200", "sender_id_alias":"28776", "company-id":1063, "sender_id_id":"Vk0XyVo8AkoSbScfERWwc4", "external_message_request_id":"", "new_state":"SENT", "fragments_count":1, "from_address":"28776", "mt_price":"0.XXX"}, "evt-tp":"message_state_change", "timestamp":"2019-08-16T01:28:44.526Z" }, "event-id":"7XuuKlVCSvSyIw_MPYXBug"}
    Log    ${RequestBody}
    ${response}=    Dispo Publisher    ${RequestBody}
    ${responseAsDict}=    Evaluate    json.loads('''${response.text}''')    modules=json
    Log    ${responseAsDict}
    Should be Equal as Strings    ${response.status_code}    200
    ${messageid}    convert to string    ${responseAsDict}
    ${finalmessageId}=    remove string    ${messageid}    {'messageIds': ['    ']}
    Log    ${finalmessageId}
    ${subscription_message}    Pubsub Msg    ${auth_json}    ${project_id}    ${dispo_subscription_topic}    ${finalmessageId}
    Log    ${subscription_message}
    ${topicMessage}    convert to string    ${subscription_message}
    Log    ${topicMessage}
    Should Contain    ${topicMessage}    "aggregator":"SYNIVERSE",
    Should Contain    ${topicMessage}    "statusInfo":"SENT",
    Should Contain    ${topicMessage}    "statusCode":1002,

002 Validate publishing a message from apigee to mom_dispo_publisher topic with 400 BAD_REQUEST(Error Handling)
    [Tags]    DispoPublisher    SmokeTest
    ${randomnum}    Generate Random String    22    WQSPV67548kjmc
    Log    ${randomnum}
    ${RequestBody}    Catenate    {"topic":"SCG-Message", "attempt":1, "event":{"fld-val-list":{"previous_state":"QUEUED", "message_request_id":"QlrNeo2cxytluN4mwejKd7", "message_id":"${randomnum}", "to_address":"+${phone_number}", "has_attachment":false, "reason_description":"SUCCESS", "application_id":${app_id}, "reason_code":"200", "sender_id_alias":"28776", "company-id":1063, "sender_id_id":"Vk0XyVo8AkoSbScfERWwc4", "external_message_request_id":"", "new_state":"BAD_REQUEST", "fragments_count":1, "from_address":"28776", "mt_price":"0.XXX"}, "evt-tp":"message_state_change", "timestamp":"2019-08-16T01:28:44.526Z" }, "event-id":"7XuuKlVCSvSyIw_MPYXBug"}
    Log    ${RequestBody}
    ${response}=    Dispo Publisher    ${RequestBody}
    ${responseAsDict}=    Evaluate    json.loads('''${response.text}''')    modules=json
    Log    ${responseAsDict}
    Should be Equal as Strings    ${response.status_code}    200
    ${messageid}    convert to string    ${responseAsDict}
    ${finalmessageId}=    remove string    ${messageid}    {'messageIds': ['    ']}
    Log    ${finalmessageId}
    ${subscription_message}    Pubsub Msg    ${auth_json}    ${project_id}    ${dispo_subscription_topic}    ${finalmessageId}
    Log    ${subscription_message}
    ${topicMessage}    convert to string    ${subscription_message}
    Log    ${topicMessage}
    Should Contain    ${topicMessage}    "aggregator":"SYNIVERSE",
    Should Contain    ${topicMessage}    "statusInfo":"BAD_REQUEST",
    Should Contain    ${topicMessage}    "statusCode":1002,

003 Validate publishing a message from apigee to mom_dispo_publisher topic with 400 EXPIRED(Error Handling)
    [Tags]    DispoPublisher    SmokeTest
    ${randomnum}    Generate Random String    22    WQSPV67548kjmc
    Log    ${randomnum}
    ${RequestBody}    Catenate    {"topic":"SCG-Message", "attempt":1, "event":{"fld-val-list":{"previous_state":"QUEUED", "message_request_id":"QlrNeo2cxytluN4mwejKd7", "message_id":"${randomnum}", "to_address":"+${phone_number}", "has_attachment":false, "reason_description":"SUCCESS", "application_id":${app_id}, "reason_code":"200", "sender_id_alias":"28776", "company-id":1063, "sender_id_id":"Vk0XyVo8AkoSbScfERWwc4", "external_message_request_id":"", "new_state":"EXPIRED", "fragments_count":1, "from_address":"28776", "mt_price":"0.XXX"}, "evt-tp":"message_state_change", "timestamp":"2019-08-16T01:28:44.526Z" }, "event-id":"7XuuKlVCSvSyIw_MPYXBug"}
    Log    ${RequestBody}
    ${response}=    Dispo Publisher    ${RequestBody}
    ${responseAsDict}=    Evaluate    json.loads('''${response.text}''')    modules=json
    Log    ${responseAsDict}
    Should be Equal as Strings    ${response.status_code}    200
    ${messageid}    convert to string    ${responseAsDict}
    ${finalmessageId}=    remove string    ${messageid}    {'messageIds': ['    ']}
    Log    ${finalmessageId}
    ${subscription_message}    Pubsub Msg    ${auth_json}    ${project_id}    ${dispo_subscription_topic}    ${finalmessageId}
    Log    ${subscription_message}
    ${topicMessage}    convert to string    ${subscription_message}
    Log    ${topicMessage}
    Should Contain    ${topicMessage}    "aggregator":"SYNIVERSE",
    Should Contain    ${topicMessage}    "statusInfo":"EXPIRED",
    Should Contain    ${topicMessage}    "statusCode":1002,
