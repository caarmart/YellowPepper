*** Settings ***
Documentation   File to store all the common API function and varibles

*** Variables ***
${REAL_BASE_URL}     https://petstore3.swagger.io/api/v3
${BASE_URL}     http://localhost:8080/api/v3/
${BY_STATUS}    pet/findByStatus
${LOGIN}    user/login
@{ORDER_STATUSES}    placed    approved    delivered
${INVENTORY}     store/inventory
${ACCEPT}       application/json
${ACCEPT2}       application/xml
${CONTENT_TYPE}     application/json
