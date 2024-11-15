*** Settings ***
Documentation   Resoruces for the API tests
Library     RequestsLibrary
Library    OperatingSystem
Library    FakerLibrary

*** Variables ***
${USER}     theUser
${PASS}     12345
${ACCEPT}   application/json
${CONTENT_TYPE}     application/json
${CONTENT_TYPE2}    application/xml
#Endpoints
${LOGIN}    user/login
${LOGOUT}   user/logout
${CREATE_USER}  user
${USER_WITH_LIST}   user/createWithList
${BASE_URL}     http://localhost:8080/api/v3/
${USER_NAME}    user/

*** Keywords ***
Perform a login request
    [Documentation]     This keyword is about to perform a GET request to log in
    ...                Expected status code     200
    ${headers}  Create Dictionary   accpet=${CONTENT_TYPE2}
    ${response}   GET    ${BASE_URL}${LOGIN}    headers=${headers}    params=username=${USER}&password=${PASS}
    Run Keyword If    ${response.status_code} != 200    Fail    Error: User couldn't login. Expected 200, but got ${response.status_code}
    Status Should Be    200

Perform a log out request
    [Documentation]     This keyword is about to perform a GET request to log out
    ...                Expected status code     200
    ${response}   GET    ${BASE_URL}${LOGOUT}     params=username=${USER}&password=${PASS}
    Run Keyword If    '${response.status_code}' != '200'    Fail    Error: User couldn't log out. Expected 200, but got ${response.status_code}
    Status Should Be    200

Sending a POST request to create an user
    [Documentation]     This keyword is about to perform a POST request to create an user
    ...                Expected status code     200
    ${headers}    Create Dictionary    accept=${ACCEPT}    Content-Type=application/json
    ${newuser}  FakerLibrary.User Name
    ${data}     Create Dictionary   id=1    username=${newuser}    password=newpass    firstname=fn    lastname=ln     email=test@email.com    phone=12345     userStatus=1
    ${response}     POST    ${BASE_URL}${CREATE_USER}       headers=${headers}     json=${data}
    Run Keyword If    ${response.status_code} != 200    Fail    Error: User not created. Expected 200, but got ${response.status_code}
    Status Should Be    200
    RETURN  ${newuser}

Sending a POST request to create a list of users
    [Documentation]     This keyword is about to perform a POST request to create a list of users
    ...                Expected status code     200
    ${headers}    Create Dictionary    accept=${ACCEPT}    Content-Type=${CONTENT_TYPE}
    ${user_data}    Get File    resources/user_data.json
    ${user_payload}    Set Variable    ${user_data}
    ${data}     Create Dictionary   id=1    json=${user_payload}
    ${response}   POST    ${BASE_URL}$${CREATE_USER}  headers=${headers}  json=${data}
    Run Keyword If    ${response.status_code} != 200    Fail    Error: User not created. Expected 200, but got ${response.status_code}
    Status Should Be    200

Look for an existing user
    [Documentation]     This keyword is about to perform a GET request to look for an user
    ...                Expected status code     200
    ${headers}  Create Dictionary   accpet=${CONTENT_TYPE2}
    ${expected_user}   Set Variable     user1
    ${response}   GET    ${BASE_URL}${USER_NAME}${expected_user}   headers=${headers}
    Run Keyword If    ${response.status_code} != 200    Fail    Error: User does not exist. Expected 200, but got ${response.status_code}
    ${json_dict}=    Evaluate    json.loads('${response.content}')    json
    ${usr}      Set Variable      ${json_dict['username']}
    ${bool1}    Evaluate    "${usr}" == "${expected_user}"
    ${bool2}    Evaluate    ${response.status_code} == 200
    Should Be True    ${bool1} and ${bool2}    USER COULDN'T BE FOUND

Look for a no existing user
    [Documentation]     This keyword is about to perform a GET request to look for a no existing user
    ...                Expected status code     404
    ${headers}  Create Dictionary   accpet=${CONTENT_TYPE2}
    ${user}   FakerLibrary.User Name   
    ${response}     Run Keyword And Return Status     GET    ${BASE_URL}${USER_NAME}${user}   headers=${headers}
    Status Should Be    404

Update the user
    [Documentation]     This keyword is about to perform a PUT request to update an existing user
    ...                Expected status code     200
    ${actual_user}  Sending a POST request to create an user
    ${new_user}     FakerLibrary.User Name

    ${headers}    Create Dictionary    accept=${ACCEPT}    Content-Type=${CONTENT_TYPE}
    ${data}     Create Dictionary   id=1    username=${new_user}    password=newpass    firstname=fn    lastname=ln     email=test@email.com    phone=12345     userStatus=1
    ${response}   PUT    ${BASE_URL}${USER_NAME}${actual_user}   headers=${headers}     json=${data}
    Run Keyword If    ${response.status_code} != 200    Fail    Error: User does not exist. Expected 200, but got ${response.status_code}
    ${json_dict}=    Evaluate    json.loads('${response.content}')    json
    ${usr}      Set Variable      ${json_dict['username']}
    ${bool1}    Evaluate    "${usr}" == "${new_user}"
    ${bool2}    Evaluate    ${response.status_code} == 200
    Should Be True    ${bool1} and ${bool2}    USER COULDN'T BE FOUND

Update a non registered user
    [Documentation]     This keyword is about to perform a PUT request to update a non existing user
    ...                Expected status code     404
    ${headers}    Create Dictionary    accept=${ACCEPT}    Content-Type=${CONTENT_TYPE}
    ${user}     FakerLibrary.User Name
    ${data}     Create Dictionary   id=1    username=newuser    password=newpass    firstname=fn    lastname=ln     email=test@email.com    phone=12345     userStatus=1
    ${response}     Run Keyword And Return Status     PUT    ${BASE_URL}${USER_NAME}${user}   headers=${headers}     json=${data}
    Status Should Be    404

Deleting an user
    [Documentation]     This keyword is about to perform a DELETE request to remove an user
    ...                Expected status code     200
    ${actual_user}  Sending a POST request to create an user
    ${response}     DELETE    ${BASE_URL}${USER_NAME}${actual_user}
    Status Should Be    200
