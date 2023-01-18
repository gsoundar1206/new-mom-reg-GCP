*** Settings ***
Resource          Resource_${environment}.txt
Resource          Resource.txt

*** Test Cases ***
Precondition - GENERATE BEARER TOKEN
    [Tags]    Precondition    SmokeTest    KeywordResponderAdmin
    ${Bearer}=    token    ${keyword_responder_admin_host_https}    ${auth_json}
    log    ${Bearer}
    Set Global Variable    ${Bearer}

Precondition
    [Tags]    KeywordResponderAdmin    SmokeTest
    ########### Delete shortcode ##########
    ${response}=    Delete Shortcode    ${keyword_responder_admin_host_https}    ${keyword_responder_admin_service}/${shortcode}/momregression
    Log    ${response.text}
    ${response}=    Delete Shortcode    ${keyword_responder_admin_host_https}    ${keyword_responder_admin_service}/${updateshortcode}/momregressiontest
    Log    ${response.text}
    ${response}=    Delete Shortcode    ${keyword_responder_admin_host_https}    ${keyword_responder_admin_service}/123456/momrrideegressiontest
    Log    ${response.text}
    ${response}=    Delete Shortcode    ${keyword_responder_admin_host_https}    ${keyword_responder_admin_service}/12155/specialchar
    Log    ${response.text}

Create/save a Shortcode using keyword responder admin
    [Tags]    KeywordResponderAdmin    SmokeTest
    ${RequestBody}    Catenate    {"name":"momregression", "shortCode":"${shortcode}","clientId": "${clientId}","keywordExpression":"Mom Test", "response":"Welcome message from Ride Test"}
    Log    ${RequestBody}
    ${ResponseBody}    Keyword Responder Admin    ${keyword_responder_admin_host}    ${RequestBody}    ${keyword_responder_admin_service}
    Log    ${ResponseBody}
    ${Result}    Convert to String    ${ResponseBody}
    Log    ${Result}
    Should Contain    ${Result}    200
    ###########Get a single shortcode##########
    ${response}=    Get Shortcode    ${keyword_responder_admin_host_https}    ${keyword_responder_admin_service}/${shortcode}
    Log    ${response.text}
    Should Be Equal As Strings    ${response.status_code}    200
    Should Contain    ${response.text}    "name":"momregression",
    Should Contain    ${response.text}    "shortCode":"${shortcode}",
    Should Contain    ${response.text}    "clientId":"${clientId}",
    Should Contain    ${response.text}    "keywordExpression":"Mom Test",
    Should Contain    ${response.text}    "response":"Welcome message from Ride Test"

Create and update a shortcode using keyword responder admin
    [Tags]    KeywordResponderAdmin    SmokeTest
    ${RequestBody}    Catenate    {"name":"momregressiontest", "shortCode":"${updateshortcode}","clientId": "${clientId}","keywordExpression":"Ride Message", "response":"Welcome to mom platform from Ride Test"}
    Log    ${RequestBody}
    ${ResponseBody}    Keyword Responder Admin    ${keyword_responder_admin_host}    ${RequestBody}    ${keyword_responder_admin_service}
    Log    ${ResponseBody}
    ${Result}    Convert to String    ${ResponseBody}
    Log    ${Result}
    Should Contain    ${Result}    200
    ###########Get a single shortcode##########
    ${response}=    Get Shortcode    ${keyword_responder_admin_host_https}    ${keyword_responder_admin_service}/${updateshortcode}
    Log    ${response.text}
    Should Be Equal As Strings    ${response.status_code}    200
    Should Contain    ${response.text}    "name":"momregressiontest",
    Should Contain    ${response.text}    "shortCode":"${updateshortcode}",
    Should Contain    ${response.text}    "clientId":"${clientId}",
    Should Contain    ${response.text}    "keywordExpression":"Ride Message",
    Should Contain    ${response.text}    "response":"Welcome to mom platform from Ride Test"
    ####### update response ##############
    ${RequestBody}    Catenate    {"name":"momregressiontest", "shortCode":"${updateshortcode}","clientId": "${clientId}","keywordExpression":"Ride Message", "response":"Welcome to mom platform from Ride Regression Test"}
    Log    ${RequestBody}
    ${ResponseBody}    Keyword Responder Admin    ${keyword_responder_admin_host}    ${RequestBody}    ${keyword_responder_admin_service}
    Log    ${ResponseBody}
    ${Result}    Convert to String    ${ResponseBody}
    Log    ${Result}
    Should Contain    ${Result}    200
    ###########Get a single shortcode##########
    ${response}=    Get Shortcode    ${keyword_responder_admin_host_https}    ${keyword_responder_admin_service}/${updateshortcode}
    Log    ${response.text}
    Should Be Equal As Strings    ${response.status_code}    200
    Should Contain    ${response.text}    "name":"momregressiontest",
    Should Contain    ${response.text}    "shortCode":"${updateshortcode}",
    Should Contain    ${response.text}    "clientId":"${clientId}",
    Should Contain    ${response.text}    "keywordExpression":"Ride Message",
    Should Contain    ${response.text}    "response":"Welcome to mom platform from Ride Regression Test"

Create and delete a shortcode using keyword responder admin
    [Tags]    KeywordResponderAdmin    SmokeTest
    ${RequestBody}    Catenate    {"name":"momrrideegressiontest", "shortCode":"123456","clientId": "${clientId}","keywordExpression":"lucky", "response":"You lucky to be part of mom platform Ride Test"}
    Log    ${RequestBody}
    ${ResponseBody}    Keyword Responder Admin    ${keyword_responder_admin_host}    ${RequestBody}    ${keyword_responder_admin_service}
    Log    ${ResponseBody}
    ${Result}    Convert to String    ${ResponseBody}
    Log    ${Result}
    Should Contain    ${Result}    200
    ###########Get a single shortcode##########
    ${response}=    Get Shortcode    ${keyword_responder_admin_host_https}    ${keyword_responder_admin_service}/123456
    Log    ${response.text}
    Should Be Equal As Strings    ${response.status_code}    200
    Should Contain    ${response.text}    "name":"momrrideegressiontest",
    Should Contain    ${response.text}    "shortCode":"123456",
    Should Contain    ${response.text}    "clientId":"${clientId}",
    Should Contain    ${response.text}    "keywordExpression":"lucky",
    Should Contain    ${response.text}    "response":"You lucky to be part of mom platform Ride Test"
    ###########deleteshortcode##########
    ${response}=    Delete Shortcode    ${keyword_responder_admin_host_https}    ${keyword_responder_admin_service}/123456/momrrideegressiontest
    Log    ${response.text}
    Should be Equal as Strings    ${response.status_code}    200

Create shortcode with special character in keywordexpression using keyword responder admin
    [Tags]    KeywordResponderAdmin
    ${RequestBody}    Catenate    {"name":"specialchar", "shortCode":"12155","clientId": "${clientId}","keywordExpression":"*", "response":"A Special Rose from Ride Test * % "}
    Log    ${RequestBody}
    ${ResponseBody}    Keyword Responder Admin    ${keyword_responder_admin_host}    ${RequestBody}    ${keyword_responder_admin_service}
    Log    ${ResponseBody}
    ${Result}    Convert to String    ${ResponseBody}
    Log    ${Result}
    Should Contain    ${Result}    200
    ###########Get a single shortcode##########
    ${response}=    Get Shortcode    ${keyword_responder_admin_host_https}    ${keyword_responder_admin_service}/12155
    Log    ${response.text}
    Should Be Equal As Strings    ${response.status_code}    200
    Should Contain    ${response.text}    "name":"specialchar",
    Should Contain    ${response.text}    "shortCode":"12155",
    Should Contain    ${response.text}    "clientId":"${clientId}",
    Should Contain    ${response.text}    "keywordExpression":"*",
    Should Contain    ${response.text}    "response":"A Special Rose from Ride Test * % "
    ###########deleteshortcode##########
    ${response}=    Delete Shortcode    ${keyword_responder_admin_host_https}    ${keyword_responder_admin_service}/12155/specialchar
    Log    ${response.text}
    Should be Equal as Strings    ${response.status_code}    200

Get All Shortcodes
    [Tags]    KeywordResponderAdmin    SmokeTest
    ${response}=    Get Shortcode    ${keyword_responder_admin_host_https}    ${get_all_shortcode}
    Log    ${response.text}
    Should Be Equal As Strings    ${response.status_code}    200
    Should Contain    ${response.text}    "shortCode":"${updateshortcode}",
    Should Contain    ${response.text}    "shortCode":"${shortcode}",
    Should Contain    ${response.text}    "clientId":"${clientId}",
    Should Contain    ${response.text}    "keywordExpression":"Ride Message",
    Should Contain    ${response.text}    "keywordExpression":"Mom Test",

ClientId value is not provided while saving a shortcode(Error Handling)
    [Tags]    KeywordResponderAdmin
    ${RequestBody}    Catenate    {"name":"momregression", "shortCode":"20201","clientId": "","keywordExpression":"Mom Test", "response":"Welcome message from Ride Test"}
    Log    ${RequestBody}
    ${ResponseBody}    Keyword Responder Admin    ${keyword_responder_admin_host}    ${RequestBody}    ${keyword_responder_admin_service}
    Log    ${ResponseBody}
    ${Result}    Convert to String    ${ResponseBody}
    Log    ${Result}
    Should Contain    ${Result}    400

Shortcode value is not provided while saving a shortcode(Error Handling)
    [Tags]    KeywordResponderAdmin
    ${RequestBody}    Catenate    {"name":"momregression", "shortCode":"","clientId": "${clientId}","keywordExpression":"Mom Test", "response":"Welcome message from Ride Test"}
    Log    ${RequestBody}
    ${ResponseBody}    Keyword Responder Admin    ${keyword_responder_admin_host}    ${RequestBody}    ${keyword_responder_admin_service}
    Log    ${ResponseBody}
    ${Result}    Convert to String    ${ResponseBody}
    Log    ${Result}
    Should Contain    ${Result}    400

Name field value is not provided while saving a shortcode(Error Handling)
    [Tags]    KeywordResponderAdmin
    ${RequestBody}    Catenate    {"name":"", "shortCode":"20201","clientId": "${clientId}","keywordExpression":"Mom Test","response":"Welcome message from Ride Test"}
    Log    ${RequestBody}
    ${ResponseBody}    Keyword Responder Admin    ${keyword_responder_admin_host}    ${RequestBody}    ${keyword_responder_admin_service}
    Log    ${ResponseBody}
    ${Result}    Convert to String    ${ResponseBody}
    Log    ${Result}
    Should Contain    ${Result}    400

KeywordExpression value is not provided while saving a shortcode(Error Handling)
    [Tags]    KeywordResponderAdmin
    ${RequestBody}    Catenate    {"name":"trialtest", "shortCode":"20201","clientId": "${clientId}","keywordExpression":"","response":"Welcome message from Ride Test"}
    Log    ${RequestBody}
    ${ResponseBody}    Keyword Responder Admin    ${keyword_responder_admin_host}    ${RequestBody}    ${keyword_responder_admin_service}
    Log    ${ResponseBody}
    ${Result}    Convert to String    ${ResponseBody}
    Log    ${Result}
    Should Contain    ${Result}    400

None of the value is provided while saving a shortcode(Error Handling)
    [Tags]    KeywordResponderAdmin
    ${RequestBody}    Catenate    {"name":"", "shortCode":"","clientId": "", "keywordExpression":"", "response":""}
    Log    ${RequestBody}
    ${ResponseBody}    Keyword Responder Admin    ${keyword_responder_admin_host}    ${RequestBody}    ${keyword_responder_admin_service}
    Log    ${ResponseBody}
    ${Result}    Convert to String    ${ResponseBody}
    Log    ${Result}
    Should Contain    ${Result}    400

Single get on non Existing Shortcode(Error Handling)
    [Tags]    KeywordResponderAdmin
    ${response}=    Get Shortcode    ${keyword_responder_admin_host_https}    ${keyword_responder_admin_service}/abcd123
    Log    ${response.text}
    Should Be Equal As Strings    ${response.status_code}    200

Delete non existing shortcode(Error Handling)
    [Tags]    KeywordResponderAdmin
    ########### Delete shortcode ##########
    ${response}=    Delete Shortcode    ${keyword_responder_admin_host_https}    ${keyword_responder_admin_service}/9999977/momregression1
    Log    ${response.text}
    Should be Equal as Strings    ${response.status_code}    400
    Should Contain    ${response.text}    Keyword-Response Combination not found for removal.

Postcondition
    [Tags]    KeywordResponderAdmin    SmokeTest
    ########### Delete shortcode ##########
    ${response}=    Delete Shortcode    ${keyword_responder_admin_host_https}    ${keyword_responder_admin_service}/${shortcode}/momregression
    Log    ${response.text}
    ${response}=    Delete Shortcode    ${keyword_responder_admin_host_https}    ${keyword_responder_admin_service}/${updateshortcode}/momregressiontest
    Log    ${response.text}
    ${response}=    Delete Shortcode    ${keyword_responder_admin_host_https}    ${keyword_responder_admin_service}/123456/momrrideegressiontest
    Log    ${response.text}
    ${response}=    Delete Shortcode    ${keyword_responder_admin_host_https}    ${keyword_responder_admin_service}/12155/specialchar
    Log    ${response.text}}
