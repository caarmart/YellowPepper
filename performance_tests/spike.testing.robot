*** Settings ***
Documentation   Test for spike testing
Library    RequestsLibrary
Resource    ../resources/api/common_resources.robot

*** Test Cases ***
Spike Testing
    [Documentation]    Simulate a sudden traffic surge to /user/login.
    ${data}    Create Dictionary    username=user    passwrod=pass
    FOR    ${i}    IN RANGE    1    500
        ${response}    GET    ${REAL_BASE_URL}/${LOGIN}    json=${data}
        Should Be Equal As Strings    ${response.status_code}    200
        Log    Request ${i}: Response Time = ${response.elapsed.total_seconds()} seconds
    END
