# API Test Scenarios

This document outlines the test scenarios for the user authentication and management endpoints. Each scenario describes the expected behavior and the implementation steps.

# User Tests

## 1. Login Request

**Scenario**: Validates user authentication.

**Implementation**:
- Sends a `GET` request to the `/user/login` endpoint.
- Passes `username` and `password` as query parameters.
- Asserts that the status code is `200`.
- The test fails if the response code is not as expected.

## 2. Create a User

**Scenario**: Validates the creation of a new user.

**Implementation**:
- Sends a `POST` request to the `/user` endpoint with user data in the payload.
- Validates that the status code indicates a successful creation `201`

## 3. Create a List of Users

**Scenario**: Validates creating multiple users in a single request.

**Implementation**:
- Sends a `POST` request to the `/user/createWithList` endpoint with a list of users in the payload.
- Validates that the status code indicates success (e.g., `200`).

## 4. Log Out Request

**Scenario**: Validates logging out an authenticated user.

**Implementation**:
- Sends a `GET` request to the `/user/logout` endpoint.
- Confirms successful execution by validating the response status.

## 5. Get an Existing User

**Scenario**: Fetches the details of a user by their username.

**Implementation**:
- Sends a `GET` request to the `/user/{username}` endpoint.
- Validates that the response status is `200` and the payload contains the user details.

## 6. No Existing User

**Scenario**: Handles requests for a non-existent user.

**Implementation**:
- Sends a `GET` request to the `/user/{nonexistent_username}` endpoint.
- Asserts that the status code is `404` (user not found).

## 7. Update a User

**Scenario**: Updates the details of an existing user.

**Implementation**:
- Sends a `PUT` request to the `/user/{username}` endpoint with the updated user data in the payload.
- Validates that the status code reflects a successful update (e.g., `200`).

## 8. Update a Non-Existing User

**Scenario**: Attempts to update a user that does not exist.

**Implementation**:
- Sends a `PUT` request to the `/user/{nonexistent_username}` endpoint.
- Asserts that the response status is `404` (user not found).

## 9. Delete a User

**Scenario**: Deletes a user by their username.

**Implementation**:
- Sends a `DELETE` request to the `/user/{username}` endpoint.
- Validates that the response status indicates a successful deletion (e.g., `200`).

---

# Store Tests

## 1. Access the Inventory Section in the Store

- **Scenario**: Sends a GET request to fetch the inventory details.

    **Implementation**:

  - The `Get the inventory section` keyword calls the `${INVENTORY}` endpoint.
  - Validates the response status (e.g., `200 OK`).
  - Ensures the returned data matches the expected inventory structure.

## 2. Place an Order for a Pet

- **Scenario**: Uses a POST request to place an order for a pet.

    **Implementation**: 
  - The `Place a new order` keyword submits an order payload.
  - Payload may include dynamic values generated using `FakerLibrary` for test data variability.
  - Verifies successful order creation with a response status of `200` or `201`.

## 3. Place an Order Incorrectly for a Pet

- **Scenario**: Attempts to place an order incorrectly using a GET request instead of POST.

    **Implementation**: 
  - The `Place a new order incorrectly` keyword intentionally sends a GET request to observe API behavior when misused.
  - Expects an error response such as `405 Method Not Allowed`.

## 4. Find a Purchase by ID

- **Scenario**: Retrieves details of a specific order using its ID.

    **Implementation**: 
  - The `Look for the purchase` keyword sends a GET request to `${ORDER}/{id}`.
  - Validates the response, ensuring fields like `status`, `petId`, and `quantity` match expectations.

## 5. Order Not Found While Looking for a Purchase

- **Scenario**: Searches for an order with an invalid ID.

    **Implementation**: 
  - The `Look for an invalid purchase` keyword queries a non-existent ID.
  - Expects a `404 Not Found` response and verifies error message consistency.

## 6. Order Not Performed While Looking for a Purchase

- **Scenario**: Simulates a bad request when searching for an order.

    **Implementation**: 
  - The `Bad request on looking for a purchase` keyword sends incomplete or malformed input.
  - Expects a `400 Bad Request` response.

## 7. Remove a Purchase Order

- **Scenario**: Deletes a specific order by ID.

    **Implementation**: 
  - The `Delete an order` keyword sends a DELETE request to `${ORDER}/{id}`.
  - Verifies successful deletion with a response status of `200` or `204`.
  - Ensures subsequent attempts to retrieve the order fail.

---

# Pet Tests

## 1. Add a New Pet

- **Test Scenario**: Sends a POST request to add a new pet with random data (e.g., name, category, tags, status).  

    **Implementation**:
  - Ensures the pet is created successfully.
  - Verifies the response status code is `200` and the returned data matches expectations.

## 2. Get a Pet by Status

- **Test Scenario**: Sends a GET request to find pets by their status (e.g., "available", "pending", "sold").  

    **Implementation**:
  - Verifies the correct status is passed in the request.
  - Ensures the response has a status code of `200`.

## 3. Get a Pet by an Invalid Status

- **Test Scenario**: Sends a GET request with an invalid status.  

    **Implementation**:
  - Ensures the response status code is `400`, indicating an invalid request.

## 4. Get a Pet by Tag

- **Test Scenario**: Sends a GET request to search for pets by tag name.  

    **Implementation**: 
  - Verifies that pets with the specified tag exist.
  - Ensures the response status code is `200`.

## 5. Get a Pet by ID

- **Test Scenario**: Sends a GET request to retrieve a pet by its ID.  

    **Implementation**:
  - Ensures the correct pet is returned for the provided ID.
  - Verifies the response status code is `200`.

## 6. Update the Pet Name

- **Test Scenario**: Sends a POST request to update a pet's name by ID.  

    **Implementation**:
  - Ensures the pet's name is updated successfully.
  - Verifies the response status code is `200`.

## 7. Update the Pet Status

- **Test Scenario**: Sends a POST request to update the pet's status by ID.  

    **Implementation**:
  - Verifies that the pet's status is updated correctly.
  - Ensures the response status code is `200`.

## 8. Update the Pet Name That Is Not Registered

- **Test Scenario**: Attempts to update the name of a pet that doesn't exist (ID not found).  

    **Implementation**:
  - Ensures the response status code is `404`, indicating the pet was not found.

## 9. Upload an Image

- **Test Scenario**: Sends a POST request to upload an image for a pet by ID.  

    **Implementation**:
  - Verifies the image upload is successful.
  - Ensures the response status code is `200`.

## 10. Upload an Image for a Pet That Is Not Registered

- **Test Scenario**: Attempts to upload an image for a non-existing pet.  

    **Implementation**:
  - Ensures the response status code is `404`, indicating the pet does not exist.

## 11. Delete a Pet

- **Test Scenario**: Sends a DELETE request to remove a pet by ID.  

    **Implementation**:
  - Verifies the pet is deleted successfully.
  - Ensures the response status code is `200`.

## 12. Verify the Delete Endpoint

- **Test Scenario**: Attempts to delete a pet that is no longer registered and verifies the request is not successful.  

    **Implementation**:
  - Ensures the pet is no longer registered.
  - Verifies the DELETE request returns a `404` error.

## 13. Update an Existing Pet

- **Test Scenario**: Sends a PUT request to update an already registered pet by ID.  

    **Implementation**:
  - Verifies the pet is updated successfully.
  - Ensures the response status code is `200`.

## 14. Update a Non-Existing Pet

- **Test Scenario**: Attempts to update a pet with an ID that doesn't exist.  

    **Implementation**:
  - Ensures the response status code is `404`, indicating the pet was not found.

---

# Technical explanation

## 1. Libraries Used

- **Robot Framework** 
  - It's used with the RequestsLibrary to interact with the API.


- **RequestsLibrary**: 
  - Essential for making HTTP requests (GET, POST, PUT, DELETE). It enables Robot Framework to interact with the API and validate the responses.
  
- **OperatingSystem**: 
  - This library is typically used for file handling or running system commands, though it’s not actively used in this specific code.
  
- **FakerLibrary**: 
  - Likely included for generating fake data (e.g., random usernames, emails).
- **common_resources.robot**: 
  - A resource file that might contain shared variables or reusable keywords, promoting efficiency and consistency across multiple tests.

## 2. Variables

Variables such as `${USER}`, `${PASS}`, and `${CONTENT_TYPE2}` serve as placeholders for commonly used values. These make it easy to modify the test setup in one place. They are used in HTTP requests and headers to ensure consistency throughout the tests.

## 3. Test Keywords

Each keyword is designed to interact with the API and perform specific actions. They are documented out.

## 4. Error Handling

Error handling is implemented using `Run Keyword If` or `Run Keyword And Return Status`. If an unexpected status code is encountered, the test will fail with an appropriate error message, such as "Error: User couldn't log," to indicate the failure cause.
Also, checks that each request returns the expected HTTP status code (200 for success, 404 for not found, 400 for invalid input).


## 5. JSON Handling

In keywords like **Look for an Existing User** and **Update the User**, the API response is expected to be in JSON format. The response content is parsed using `json.loads()` into a Python dictionary. This parsed data is validated to ensure the user data matches the expected values.

## 6. Modular Design

Tests are structured into reusable keywords, making the code modular and maintainable. For instance, the **Sending a POST Request to Create a User** keyword is used for both creating a single user and a list of users, reducing code repetition.

## 7. Potential Improvements

- **Test Data Generation**: Leverage the `FakerLibrary` to generate dynamic test data (e.g., random usernames and emails) instead of hard-coding values (e.g., `username=newuser`).
  
- **Response Validation**: Add more robust response validation to check the actual content of the response (e.g., validating user details), in addition to the status code validation.

- **Logging**: Improve logging by adding detailed information about request bodies and responses. This would aid in debugging and provide deeper insights during test failures.

- **Image Upload:** Tests for uploading an image, verifying correct handling of binary data and metadata for an existing pet, as well as handling of invalid pet IDs for image uploads.

- **Test Case Coverage:** Your test suite covers a wide range of scenarios for the pet store API, including:
CRUD Operations: Create (add a pet), Retrieve (find a pet by ID, status, tag), Update (name, status), Delete (remove pet).
