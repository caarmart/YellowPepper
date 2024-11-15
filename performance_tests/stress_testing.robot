*** Settings ***
Documentation   Scenario for stress testing
Library           RequestsLibrary
Library           Collections
Resource    ../resources/api/common_resources.robot

*** Test Cases ***
Stress Testing
    [Documentation]    Incrementally increase the load until failure.
    ${load}=    Set Variable    10
    WHILE    ${load} < 1000
        ${response_times}    Create List
        FOR    ${i}    IN RANGE    ${load}
            ${url}    Set Variable    ${REAL_BASE_URL}/${BY_STATUS}?status=available
            ${response}    GET    ${url}
            ${elapsed}    Get Elapsed Time From Response    ${response}
            Append To List    ${response_times}    ${elapsed}
        END
        ${response_times_str}=    Convert List To String    ${response_times}
        Log    Load ${load}: Response Times = ${response_times_str}
        ${load}=    Evaluate    ${load} + 50
    END

*** Keywords ***
Get Elapsed Time From Response
    [Arguments]    ${response}
    ${elapsed}=    Evaluate    str(${response.elapsed.total_seconds()})
    RETURN    ${elapsed}

Convert List To String
    [Arguments]    ${list}
    ${string}    Catenate    SEPARATOR=,    @{list}
    RETURN    ${string}
