*** Settings ***
Documentation   This test suite is about all the STORE endpoints
Resource    ../resources/api/store_api.robot

*** Test Cases ***
Access to the inventory section in the store
    [Documentation]     Scenario to request a GET to access to inventory
    Get the inventory section

Place an order for a pet
    [Documentation]     Scenario to request a POST to place a new order
    Place a new order

Place incorrectly an order for a pet
    [Documentation]     Scenario to request incorrectly a POST using GET to place a new order
    Place a new order incorrectly

Find a purchase by ID
    [Documentation]     Scenario to look for a purchase using the ID
    Look for the purchase

Order not found while looking for a purchase
    [Documentation]     Scenario to look for a non existing purchase
    Look for an invalid purchase

Order no performed while looking for a purhase
    [Documentation]     Scenario to make an error to look find a purchase
    Bad request on lokking for a purchase

Remove a purchase order
    [Documentation]     Scenario to delete an order
    Delete and order
