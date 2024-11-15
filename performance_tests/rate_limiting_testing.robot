*** Settings ***
Documentation   Scenario for Rate Limiting and Throttling testing
Library    RequestsLibrary
Resource    ../resources/api/common_resources.robot

*** Test Cases ***
Rate Limiting
    [Documentation]    Simulate exceeding rate limits on /user/logout.
    FOR    ${i}    IN RANGE    1    100
        ${response}    GET     ${REAL_BASE_URL}/user/logout
        Log    Request ${i}: Status = ${response.status_code}
    END
