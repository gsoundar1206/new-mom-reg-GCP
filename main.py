# Copyright 2015 Google Inc. All Rights Reserved.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.


import os
import robot
import logging
import re


from flask import Flask, request
from google.cloud import storage
from datetime import datetime
from webexteamssdk import WebexTeamsAPI
import xml.etree.ElementTree as ET


app = Flask(__name__)

api = WebexTeamsAPI(access_token='ZWE1Nzk3YTUtMjQzMC00NzI5LTk1M2YtMzQ0NTE2Y2FmMTIzODMwYmQ3ZDAtMjlm_PF84_6e827ded-20dc-49e0-a0c3-da075da790fc')

# Webex Teams Space ID
dev_space_id = '5dfbe070-b2df-11e9-be8e-9b895536ccbf'
test_space_id = '741b7b40-b2df-11e9-aafa-6bb596d49a94'
stage_space_id = 'a95402d0-945f-11e9-8533-016c98413bf2'
prod_space_id = '3c1336d0-c828-11e9-9ebc-e5ab93cf8f1b'

# Storage Detail
storage_bucket = 'mom-regression-suite-results-storage'


@app.route('/')
def base_page():
    f = open('result.html', 'wb')
    message = """<link rel="shortcut icon" href="#"><html>
    <head></head>
    <h1>MOM ROBOT TEST FRAMEWORK SUITE</h1>
    <h2>Trigger suite</h2>
    <body><p><a href=""" + request.base_url+"""trigger-suite/>""" + request.base_url+"""trigger-suite/</a><p></body>
    <h2>Access Report</h2>
    <body><p><a href=""" + request.base_url+"""report>""" + request.base_url+"""report</a> <p></body>
    <h2>Access Log</h2>
    <body><a href=""" + request.base_url+"""log>""" + request.base_url+"""log</a> <p></body>
    </html>"""
    f.write(str.encode(message))
    f.close()
    return open(os.path.abspath(os.getcwd())+'/result.html','r', encoding='utf-8').read()

@app.route('/trigger-suite/')
def trigger_suite():
    try:
        # Identify environment from Rest URL
        environment_from_url = re.search(r'suite-(.*?)-', request.base_url).group(1)

        # Differentiate between Smoke and Regression
        is_smoke = re.search("smoke", request.base_url)
        if is_smoke:
            environment = environment_from_url + "-smoke"
        else:
            environment = environment_from_url

        # Get Absolute path
        abspath = os.path.abspath(os.getcwd())

        print('environment:'+environment)
        print('Absolute path:'+abspath)

        # Get space id and tag based on environment
        include_tests = ''
        exclude_tests = ''
        if environment_from_url == 'dev':
            space_id = dev_space_id
            exclude_tests = 'DoNotRunORStageOnlyORTestOnly'
        elif environment_from_url == 'test':
            space_id = test_space_id
            if is_smoke:
                include_tests = 'SmokeTest'
            else:
                exclude_tests = 'DoNotRunORStageOnly'
        elif environment_from_url == 'stage':
            space_id = stage_space_id
            if is_smoke:
                include_tests = 'SmokeTest'
            else:
                exclude_tests = 'DoNotRun*ORTestOnly'
        elif environment_from_url == 'prod':
            space_id = prod_space_id
            include_tests = 'SmokeTest'
        else:
            space_id = dev_space_id    # default environment - to communicate errors
            raise Exception('could not resolve environment')

        # Run the robot suite
        robot.run(abspath+"/src/test/robotframework/acceptance", variable='environment:'+environment_from_url, include=include_tests, exclude=exclude_tests)
        
        # Upload to google cloud storage
        client = storage.Client().from_service_account_json(abspath+'/mom-regression-suite-sa-key.json')
        bucket = client.get_bucket(storage_bucket)
        date_time = datetime.now().strftime("%m-%d-%Y-%H:%M:%S")
        blob = bucket.blob(''+environment+'/'+date_time+'/report.html')
        blob.upload_from_filename(filename=abspath+"/report.html")
        bucket2 = client.get_bucket(storage_bucket)
        blob2 = bucket2.blob(''+environment+'/'+date_time+'/log.html')
        blob2.upload_from_filename(filename=abspath+"/log.html")

        # Get stats from output.xml
        tree = ET.parse(abspath+'/output.xml')
        stats = ''
        for stat in tree.getroot().findall("./statistics/total/stat"):
            stats += stat.text + ':\t' + stat.attrib.__str__() + '\n'

        # form message string to send out message on Webex Teams
        message_string = '### GCP Test Automation \n' \
                         'Environment: **'+environment.upper()+'** \n' \
                         'Stats: \n'+stats+' ' \
                         'Robot Framework Test Results: https://console.cloud.google.com/storage/browser/'+storage_bucket+'/'+environment+'/'+date_time+''
        api.messages.create(space_id, markdown=message_string)
        return "Successfully triggered"
    except:
        message_string = '### GCP Test Automation \n' \
                         'Environment: '+environment.upper()+' \n' \
                         'Result: Failed'
        api.messages.create(space_id, markdown=message_string)
        return "regression failed"


@app.route('/<string:page_name>/')
def render_static(page_name):
    return open(os.path.abspath(os.getcwd())+'/%s.html' % page_name,'r', encoding='utf-8').read()

@app.errorhandler(500)
def server_error(e):
    logging.exception('An error occurred during a request.')
    return """
    An internal error occurred: <pre>{}</pre>
    See logs for full stacktrace.
    """.format(e), 500

if __name__ == "__main__":
    app.run(debug=True, host='0.0.0.0', port=int(os.environ.get('PORT', 8080)))