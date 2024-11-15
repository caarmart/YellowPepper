*** Settings ***
Documentation   Resoruces for the store API tests
Library     RequestsLibrary
Library    OperatingSystem
Library    FakerLibrary
Resource    common_resources.robot

*** Variables ***
${API_KEY}
${INVENTORY}     store/inventory
${ORDER}    store/order
@{ORDER_STATUSES}    placed    approved    delivered
@{ORDER_KEYS}   id  petId   quantity    shipDate    status  complete

*** Keywords ***

Get the inventory section
    [Documentation]     Keyword to access to return the pet inventory by status
    ...                Expected status code     200
    ${headers}    Create Dictionary    accept=${ACCEPT}    api_key=${API_KEY}
    ${response}     GET    ${BASE_URL}${INVENTORY}   headers=${headers}
    ${json_dict}    Evaluate    json.loads('${response.content}')    json
    ${bool1}    Evaluate    all(key in ${json_dict} for key in @{ORDER_STATUSES})
    ${bool2}    Evaluate    ${response.status_code} == 200
    Should Be True    ${bool1} and ${bool2}     ONE OF THE STATUS ARE NOT PRESENT

Place a new order
    [Documentation]     Keyword to place an order for a pet
    ...                Expected status code     200
    ${headers}    Create Dictionary    accept=${ACCEPT}    Content-Type=${CONTENT_TYPE}
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
    ${response}     POST    ${BASE_URL}${ORDER}   headers=${headers}    json=${data}
    ${json_dict}    Evaluate    json.loads('${response.content}')    json
    ${bool1}    Evaluate    all(${json_dict}.get(key) == ${data}.get(key) for key in ${data})
    ${bool2}    Evaluate    ${response.status_code} == 200
    Should Be True    ${bool1} and ${bool2}     THE INFORMATION IS NOT THE SAME IN THE BODY RESPONSE

Place a new order incorrectly
    [Documentation]     Keyword to place an order for a pet using a GET
    ...                Expected status code     405
    ${headers}    Create Dictionary    accept=${ACCEPT}    Content-Type=${CONTENT_TYPE}
    ${response}   Run Keyword And Return Status  GET    ${BASE_URL}${ORDER}   headers=${headers}
    Status Should Be    405

Look for the purchase
    [Documentation]     Keyword to look for a purchase
    ...                Expected status code     200
    ${headers}    Create Dictionary    accept=${ACCEPT}
    ${response}     GET    ${BASE_URL}${ORDER}/1   headers=${headers}
    ${json_dict}    Evaluate    json.loads('${response.content}')     json
    ${bool1}    Evaluate    all(key in ${json_dict} for key in @{ORDER_KEYS})
    ${bool2}    Evaluate    all(value not in ["", None] for value in ${json_dict}.values())
    ${bool3}    Evaluate    ${response.status_code} == 200
    Should Be True    ${bool1} and ${bool2} and ${bool3}    INFORMATION IS MISSING IN THE RESPONSE OR PURCHASE NOT FOUND

Look for an invalid purchase
    [Documentation]     Keyword to look for a non existing purchase using an ID that does not exist
    ...                Expected status code     404
    ${headers}    Create Dictionary    accept=${ACCEPT}
    ${response}     Run Keyword And Return Status    GET    ${BASE_URL}${ORDER}/6   headers=${headers}
    Status Should Be    404

Bad request on lokking for a purchase
    [Documentation]     Keyword to look throw a bad requst sending a random character
    ...                Expected status code     400
    ${headers}    Create Dictionary    accept=${ACCEPT}
    ${fake_id}      Random Letter
    ${response}     Run Keyword And Return Status    GET    ${BASE_URL}${ORDER}/${fake_id}   headers=${headers}
    Status Should Be    400

Delete and order
    [Documentation]     Keyword to remove a purchase order
    ...                Expected status code     200
    ${fake_id}      Random Number
    ${response}     Run Keyword And Return Status    DELETE    ${BASE_URL}${ORDER}/${fake_id}
    Status Should Be    200
