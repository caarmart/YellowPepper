*** Settings ***
Documentation   Resoruces for the store PET API tests
Resource    ../resources/api/pet_api.robot

*** Test Cases ***
Add a new pet
    [Documentation]     Scenario to add a pet
    Adding a pet

Get a pet by status
    [Documentation]     Scenario to look for a pet by its status
    Finding a pet by the status

Get a pet by an invalid status
    [Documentation]     Scenario to look for a pet by an invalid status
    Finding a pet by a invalid status

Get a pet by a tag
    [Documentation]     Scenario to look for a pet by a tag
    Finding a pet by the tag name

Get a pet by an existing ID
    [Documentation]     Scenario to look for a pet by an ID
    Finding a pet by ID

Update the pet name
    [Documentation]     Scenario to update the pet name using its ID
    Updating the pet name

Update the pet status
    [Documentation]     Scenario to update the pet status using its ID
    Updating the pet status

Update the pet name that is not registered
    [Documentation]     Scenario to update the pet name using a non existing ID
    Updating a pet that is not in the store


Upload an image of the pet
    [Documentation]     Scenario to upload the pet image using its ID
    Upload an image

Upload an image of the pet that is not registered
    [Documentation]     Scenario to upload the pet image using an invalid ID
    Upload an image of a non existing pet ID

Delete a pet
    [Documentation]     Scenario to remove a pet form the store
    Remove pet from the store

Verify Delete endpoint
    [Documentation]     Scenario to validate whether it's throwing an error
    ...                to remove a pet that is no registered anymore
    Validate DELETE endpoint

Updating an existing pet
    [Documentation]     Scenario to update a pet that is already registered with the PUT request
    Update a pet from the store

Updating a non existing pet
    [Documentation]     Scenario to update a pet that is no registered with the PUT request
    Update a pet that is not in the store


