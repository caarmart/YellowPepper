*** Settings ***
Documentation   Scenario for latency testing
Library    RequestsLibrary
Resource    ../resources/api/common_resources.robot
Library    FakerLibrary

*** Test Cases ***
Latency Testing
    [Documentation]    Test API under varying network latencies.
    ${latencies}=    Create List    100    200    500

    ${id}      Random Number
    ${petId}      Random Number
    ${quantity}      Random Number
    ${faker_date}      Date
    ${new_date}     Set Variable    ${faker_date}T00:00:00.000+00:00
    ${status}       Evaluate      random.choice(@{ORDER_STATUSES})
    ${complete}     Boolean
    ${data}     Create Dictionary
    ...         id=${id}
    ...         petId=${petId}
    ...         quantity=${quantity}
    ...         shipDate=${new_date}
    ...         status=${status}
    ...         complete=${complete}

    FOR    ${latency}    IN    @{latencies}
        ${response}=    POST    ${REAL_BASE_URL}/store/order    json=${data}
        Log    Latency ${latency}ms: Response Time = ${response.elapsed.total_seconds()} seconds
    END
