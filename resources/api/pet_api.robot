*** Settings ***
Documentation   Resoruces for the store API tests
Library     RequestsLibrary
Library    OperatingSystem
Library    FakerLibrary
Library     XML
Resource    common_resources.robot

*** Variables ***
@{PET_STATUS}       available   pending     sold
${PET}      pet
${BY_TAGS}  pet/findByTags
${CONTENT_TYPE3}    application/octet-stream
${IMAGE_FILE_PATH}      resources/api/photo.jpg

*** Keywords ***
Adding a pet
    [Documentation]     Keyword to add a new pet to sending a POST request
    ...                Expected status code     200
    ...                Returns the pet's data to create
    ${headers}    Create Dictionary    accept=${ACCEPT2}    Content-Type=${CONTENT_TYPE}
    ${id}         Random Number    1    10000
    ${name}       Name
    ${category_id}  Random Number    1    10
    ${category_name}  Word
    ${photo_urls}     Image Url
    ${tag_id}      Random Number    1    100
    ${tag_name}    Word
    ${status}      Evaluate    random.choice(@{PET_STATUS})
    ${category}    Create Dictionary    id=${category_id}    name=${category_name}
    ${tag}         Create Dictionary    id=${tag_id}    name=${tag_name}
    ${tags}        Create List          ${tag}
    ${data}        Create Dictionary
    ...            id=${id}
    ...            name=${name}
    ...            category=${category}
    ...            photo_urls=${photo_urls}
    ...            tags=${tags}
    ...            status=${status}

    ${RESPONSE}    POST    ${BASE_URL}${PET}    headers=${headers}    json=${data}
    Run Keyword If    ${response.status_code} != 200    Fail    Error: Pet not created. Expected 200, but got ${response.status_code}
    Status Should Be    200
    RETURN  ${data}

Finding a pet by the status
        [Documentation]     Keyword to add a look a pet by its status sending a GET
        ...                Expected status code     200
        ${headers}    Create Dictionary    accept=${ACCEPT2}
        ${status}   Evaluate    random.choice(@{PET_STATUS})
        ${response}    GET    ${BASE_URL}${BY_STATUS}   headers=${headers}     params=status=${status}
        Run Keyword If    ${response.status_code} != 200    Fail    Error: Invalid status. Expected 200, but got ${response.status_code}
        Status Should Be    200

Finding a pet by a invalid status
        [Documentation]     Keyword to add a look a pet by a invalid status sending a GET
        ...                Expected status code     400
        ${headers}    Create Dictionary    accept=${ACCEPT2}
        ${status}   Word
        ${response}     Run Keyword And Return Status   GET    ${BASE_URL}${BY_STATUS}   headers=${headers}     params=status=${status}
        Status Should Be    400

Finding a pet by the tag name
        [Documentation]     Keyword to add a look a pet by its tag name sending a GET
        ...                Expected status code     200
        ${tag_name}     Adding a pet

        ${headers}    Create Dictionary    accept=${ACCEPT2}
        ${response}    GET    ${BASE_URL}${BY_TAGS}   headers=${headers}     params=tags=${tag_name}
        Run Keyword If    ${response.status_code} != 200    Fail    Error: No pet found with this tag. Expected 200, but got ${response.status_code}
        Status Should Be    200

Finding a pet by ID
        [Documentation]
        ${data}     Adding a pet
        ${id}   Set Variable    ${data}[id]
        Looking a pet by ID     ${id}


Looking a pet by ID
        [Documentation]     Keyword to add a look a pet by ID sending a GET
        ...                Expected status code     200
        [Arguments]     ${id}
        ${headers}    Create Dictionary    accept=${ACCEPT2}
        ${response}    GET    ${BASE_URL}${PET}/${id}  headers=${headers}
        ${xml}    Parse XML    ${response.text}
        ${actual_id}    Get Element Text    ${xml}    ./id
        ${bool1}    Evaluate    ${id} == ${actual_id}
        ${bool2}    Evaluate    ${response.status_code} == 200
        Should Be True    ${bool1} and ${bool2}     Error: No pet found with this ID. Expected 200, but got ${response.status_code}
        RETURN      ${bool2}

Updating the pet name
        [Documentation]     Keyword to add a update the pet name sending a POST and using the ID as the key
        ...                Expected status code     200
        ${data}     Adding a pet
        ${new_name}     Name
        ${headers}    Create Dictionary    accept=${ACCEPT2}
        ${response}    POST    ${BASE_URL}${PET}/${data}[id]   headers=${headers}   params=name=${new_name}
        ${xml}    Parse XML    ${response.text}
        ${actual_name}    Get Element Text    ${xml}    ./name
        ${bool1}    Evaluate    '${new_name}' == '${actual_name}'
        ${bool2}    Evaluate    ${response.status_code} == 200
        Should Be True    ${bool1} and ${bool2}     Error: No pet found with this ID. Expected 200, but got ${response.status_code}

Updating a pet that is not in the store
        [Documentation]     Keyword to add a update the pet name sending a POST and using the ID that doesn't exist
        ...                Expected status code     404
        ${id}       Random Number
        ${new_name}     Name
        ${headers}    Create Dictionary    accept=${ACCEPT2}
        ${response}   Run Keyword And Return Status   POST    ${BASE_URL}${PET}/${id}   headers=${headers}   params=name=${new_name}
        Status Should Be    404

Updating the pet status
        [Documentation]     Keyword to add a update the pet status sending a POST and using the ID as the key
        ...                Expected status code     200
        ${data}     Adding a pet
        ${new_status}     Evaluate    random.choice(@{PET_STATUS})
        ${headers}    Create Dictionary    accept=${ACCEPT2}
        ${params}       Create Dictionary   name=${data}[name]  status=${new_status}
        ${response}    POST    ${BASE_URL}${PET}/${data}[id]   headers=${headers}   params=${params}
        ${xml}    Parse XML    ${response.text}
        ${actual_name}    Get Element Text    ${xml}    ./status
        ${bool1}    Evaluate    '${new_status}' == '${actual_name}'
        ${bool2}    Evaluate    ${response.status_code} == 200
        Should Be True    ${bool1} and ${bool2}     Error: No pet found with this ID. Expected 200, but got ${response.status_code}

Upload an image
        [Documentation]     Keyword to add a upload an image sending a POST and using the ID as the key
        ...                Expected status code     200
        ${data}     Adding a pet
        ${headers}    Create Dictionary    accept=${ACCEPT2}    Content-Type=${CONTENT_TYPE3}
        ${metadata}    Word
        ${binary_data}    Get Binary File    ${IMAGE_FILE_PATH}
        ${response}    POST    ${BASE_URL}${PET}/${data}[id]/uploadImage  headers=${headers}   params=${metadata}   data=${binary_data}
        Status Should Be    200

Upload an image of a non existing pet ID
        [Documentation]     Keyword to add a upload an image sending a POST and using an id that does not exist
        ...                Expected status code     404
        ${id}       Random Number
        ${headers}    Create Dictionary    accept=${ACCEPT2}    Content-Type=${CONTENT_TYPE3}
        ${metadata}    Word
        ${binary_data}    Get Binary File    ${IMAGE_FILE_PATH}
        ${response}    Run Keyword And Return Status     POST    ${BASE_URL}${PET}/${id}/uploadImage  headers=${headers}   params=${metadata}   data=${binary_data}
        Status Should Be    404

Remove pet from the store
        [Documentation]     Keyword to add a delete a pet using its ID sending it through a DELETE request
        ...                Expected status code     200
        ${id}       Random Number
        ${response}    Run Keyword And Return Status     DELETE    ${BASE_URL}${PET}/${id}
        Status Should Be    200

Validate DELETE endpoint
        [Documentation]     Keyword to verify if the DELETE request can check if pet is registered first
        ...                Expected status code     200
        ${id}       Random Number
        ${response}    Run Keyword And Return Status     DELETE    ${BASE_URL}${PET}/${id}
        ${is_registered}    Run Keyword And Return Status   Looking a pet by ID     ${id}
        Should Be True    not ${response} and ${is_registered}     USER IS NO REGISTERED. IT SHOULD NOT PERFORMED THE DELETED REQUEST

Update a pet from the store
    [Documentation]     Keyword to add a update a pet using its ID
        ...                Expected status code     200
        ${data}     Adding a pet
        ${headers}    Create Dictionary    accept=${ACCEPT2}    Content-Type=${CONTENT_TYPE}

        ${id}         Set Variable  ${data}[id]
        ${name}       Name
        ${category_id}  Random Number    1    10
        ${category_name}  Word
        ${photo_urls}     Image Url
        ${tag_id}      Random Number    1    100
        ${tag_name}    Word
        ${status}      Evaluate    random.choice(@{PET_STATUS})
        ${category}    Create Dictionary    id=${category_id}    name=${category_name}
        ${tag}         Create Dictionary    id=${tag_id}    name=${tag_name}
        ${tags}        Create List          ${tag}
        ${new_data}        Create Dictionary
        ...            id=${id}
        ...            name=${name}
        ...            category=${category}
        ...            photo_urls=${photo_urls}
        ...            tags=${tags}
        ...            status=${status}

        ${response}    PUT    ${BASE_URL}${PET}   headers=${headers}   json=${new_data}
        Status Should Be    200

Update a pet that is not in the store
        [Documentation]     Keyword to add a update a pet that is no registered using PUT request
        ...                Expected status code     404
        ${headers}    Create Dictionary    accept=${ACCEPT2}    Content-Type=${CONTENT_TYPE}

        ${id}         Random Number
        ${name}       Name
        ${category_id}  Random Number    1    10
        ${category_name}  Word
        ${photo_urls}     Image Url
        ${tag_id}      Random Number    1    100
        ${tag_name}    Word
        ${status}      Evaluate    random.choice(@{PET_STATUS})
        ${category}    Create Dictionary    id=${category_id}    name=${category_name}
        ${tag}         Create Dictionary    id=${tag_id}    name=${tag_name}
        ${tags}        Create List          ${tag}
        ${new_data}        Create Dictionary
        ...            id=${id}
        ...            name=${name}
        ...            category=${category}
        ...            photo_urls=${photo_urls}
        ...            tags=${tags}
        ...            status=${status}

        ${response}     Run Keyword And Return Status    PUT    ${BASE_URL}${PET}   headers=${headers}   json=${new_data}
        Status Should Be    404
