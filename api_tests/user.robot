*** Settings ***
Documentation    This is a test suite for the USER endpoints
Resource    ../resources/api.robot


*** Test Cases ***
Login request
    [Documentation]    Scenario to validate the authentication
    Perform a login request

Create an user
    [Documentation]     Scenario to create an user
    Sending a POST request to create an user

Creating a list of users
    [Documentation]     Scenario to create an list a users
    Sending a POST request to create a list of users

Log out request
    [Documentation]    Scenario to validate the log out request
    Perform a log out request

Get an existing user
    [Documentation]    Scenario to look for an existing client by its user name
    Look for an existing user

No existing user
    [Documentation]    Scenario to look for a no existing client by a user name that doesn't exist
    Look for a no existing user

Update an user
    [Documentation]    Scenario to update the user name of an existing client
    Update the user

Update an user that doesn't exist
    [Documentation]    Scenario to update the user name of a non existing client
    Update a non registered user

Delete an user
    [Documentation]    Scenario to delete an user
    Deleting an user
