*** Settings ***
Documentation   Test for load testing
Library    RequestsLibrary
Resource    ../resources/api/common_resources.robot

*** Test Cases ***
Load Testing
    [Documentation]    Simulate concurrent user requests to /store/inventory.
    FOR    ${i}    IN RANGE    1    100
        ${response}    GET      ${REAL_BASE_URL}/${INVENTORY}
        Should Be Equal As Strings    ${response.status_code}    200
        Log    Request ${i}: Response Time = ${response.elapsed.total_seconds()} seconds
    END
