*** Settings ***
Documentation   Resoruces for the user API tests
Library     RequestsLibrary
Library    OperatingSystem
Library    FakerLibrary
Resource    common_resources.robot

*** Variables ***
${USER}     theUser
${PASS}     12345
${CONTENT_TYPE2}    application/xml
############### ENDPOINTS ##############
${LOGIN}    user/login
${LOGOUT}   user/logout
${CREATE_USER}  user
${USER_WITH_LIST}   user/createWithList
${USER_NAME}    user/

*** Keywords ***
Perform a login request
    [Documentation]     This keyword is about to perform a GET request to log in
    ...                 Sends a GET request to the login endpoint with username and password as query parameters.
    ...                 Fails the test if the response status code is not 200.
    ...                 Expected status code     200
    ${headers}  Create Dictionary   accpet=${CONTENT_TYPE2}
    ${response}   GET    ${BASE_URL}${LOGIN}    headers=${headers}    params=username=${USER}&password=${PASS}
    Run Keyword If    ${response.status_code} != 200    Fail    Error: User couldn't login. Expected 200, but got ${response.status_code}
    Status Should Be    200

Perform a log out request
    [Documentation]     This keyword is about to perform a GET request to log out
    ...                 Sends a GET request to log out the user and expects a 200 status code for successful logout.
    ...                 Expected status code     200
    ${response}   GET    ${BASE_URL}${LOGOUT}     params=username=${USER}&password=${PASS}
    Run Keyword If    '${response.status_code}' != '200'    Fail    Error: User couldn't log out. Expected 200, but got ${response.status_code}
    Status Should Be    200

Sending a POST request to create an user
    [Documentation]     This keyword is about to perform a POST request to create an user
    ...                 Sends a POST request with a JSON object containing user details.
    ...                 Verifies that the response status code is 200, confirming successful user creation.
    ...                 Expected status code     200
    ${headers}    Create Dictionary    accept=${ACCEPT}    Content-Type=application/json
    ${newuser}  User Name
    ${data}     Create Dictionary   id=1    username=${newuser}    password=newpass    firstname=fn    lastname=ln     email=test@email.com    phone=12345     userStatus=1
    ${response}     POST    ${BASE_URL}${CREATE_USER}       headers=${headers}     json=${data}
    Run Keyword If    ${response.status_code} != 200    Fail    Error: User not created. Expected 200, but got ${response.status_code}
    Status Should Be    200
    RETURN  ${newuser}

Sending a POST request to create a list of users
    [Documentation]     This keyword is about to perform a POST request to create a list of users
    ...                 Sends a POST request with a JSON array of users, fetched from the `user_data.json` file.
    ...                 Fails if the response status code is not 200.
    ...                 Expected status code     200
    ${headers}    Create Dictionary    accept=${ACCEPT2}    Content-Type=${CONTENT_TYPE}
    ${user_data}  Get File    resources/api/user_data.json
    ${response}   POST    ${BASE_URL}${USER_WITH_LIST}   headers=${headers}  data=${user_data}
    Run Keyword If    ${response.status_code} != 200    Fail    Error: User not created. Expected 200, but got ${response.status_code}
    Status Should Be    200

Look for an existing user
    [Documentation]     This keyword is about to perform a GET request to look for an user
    ...                 Performs a GET request to check if a user exists and expects a 200 status code with user data.
    ...                 Verifies that the username in the response matches the expected user.
    ...                 Expected status code     200
    ${headers}  Create Dictionary   accpet=${CONTENT_TYPE2}
    ${expected_user}   Set Variable     user1
    ${response}   GET    ${BASE_URL}${USER_NAME}${expected_user}   headers=${headers}
    Run Keyword If    ${response.status_code} != 200    Fail    Error: User does not exist. Expected 200, but got ${response.status_code}
    ${json_dict}    Evaluate    json.loads('${response.content}')    json
    ${usr}      Set Variable      ${json_dict['username']}
    ${bool1}    Evaluate    "${usr}" == "${expected_user}"
    ${bool2}    Evaluate    ${response.status_code} == 200
    Should Be True    ${bool1} and ${bool2}    USER COULDN'T BE FOUND

Look for a no existing user
    [Documentation]     This keyword is about to perform a GET request to look for a no existing user
    ...                 Checks for a non-existing user and expects a 404 status code (Not Found).
    ...                 Expected status code     404
    ${headers}  Create Dictionary   accpet=${CONTENT_TYPE2}
    ${user}   User Name
    ${response}     Run Keyword And Return Status     GET    ${BASE_URL}${USER_NAME}${user}   headers=${headers}
    Status Should Be    404

Update the user
    [Documentation]     This keyword is about to perform a PUT request to update an existing user
    ...                 Sends a PUT request to modify an existing user's data.
    ...                 Confirms the update by comparing the username in the response with the expected value.
    ...                 Expected status code     200
    ${actual_user}  Sending a POST request to create an user
    ${new_user}     User Name

    ${headers}    Create Dictionary    accept=${ACCEPT}    Content-Type=${CONTENT_TYPE}
    ${data}     Create Dictionary   id=1    username=${new_user}    password=newpass    firstname=fn    lastname=ln     email=test@email.com    phone=12345     userStatus=1
    ${response}   PUT    ${BASE_URL}${USER_NAME}${actual_user}   headers=${headers}     json=${data}
    Run Keyword If    ${response.status_code} != 200    Fail    Error: User does not exist. Expected 200, but got ${response.status_code}
    ${json_dict}    Evaluate    json.loads('${response.content}')    json
    ${usr}      Set Variable      ${json_dict['username']}
    ${bool1}    Evaluate    "${usr}" == "${new_user}"
    ${bool2}    Evaluate    ${response.status_code} == 200
    Should Be True    ${bool1} and ${bool2}    USER COULDN'T BE FOUND

Update a non registered user
    [Documentation]     This keyword is about to perform a PUT request to update a non existing user
    ...                 A negative test case that attempts to update a non-existent user, expecting a 404 status code.
    ...                 Expected status code     404
    ${headers}    Create Dictionary    accept=${ACCEPT}    Content-Type=${CONTENT_TYPE}
    ${user}     User Name
    ${data}     Create Dictionary   id=1    username=newuser    password=newpass    firstname=fn    lastname=ln     email=test@email.com    phone=12345     userStatus=1
    ${response}     Run Keyword And Return Status     PUT    ${BASE_URL}${USER_NAME}${user}   headers=${headers}     json=${data}
    Status Should Be    404

Deleting an user
    [Documentation]     This keyword is about to perform a DELETE request to remove an user
    ...                 Sends a DELETE request to remove the user.
    ...                 Verifies successful deletion by checking for a 200 status code in the response.
    ...                 Expected status code     200
    ${actual_user}  Sending a POST request to create an user
    ${response}     DELETE    ${BASE_URL}${USER_NAME}${actual_user}
    Status Should Be    200
