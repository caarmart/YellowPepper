# Performance Testing

## Overview

- This page contains all the performance tests with their explanation and potential performance issues
---

# Latency Testing

- The Latency Testing scenario simulates API requests to evaluate the performance of the /store/order endpoint under varying network latencies. The test dynamically generates request data and iteratively sends POST requests while introducing artificial latencies of 100ms, 200ms, and 500ms. The response time for each latency is logged for analysis.

### Response Times

 **Passed with the following information:**

- **Latency 100ms**: Response time = **0.48299 seconds**
- **Latency 200ms**: Response time = **0.401847 seconds**
- **Latency 500ms**: Response time = **0.496193 seconds**

### Analysis
   - **Inconsistent Response Times**:
     - Variability in response times under controlled conditions suggests inefficiencies or bottlenecks (e.g., resource contention, database performance).
   - **Scaling Concerns**:
     - Minimal differences across latencies indicate that the API may not effectively scale with increased load or network variability.

---

# Load Testing

This test case simulates **load testing** on the `/store/inventory` API endpoint to evaluate the server's ability to handle multiple requests efficiently and provide consistent responses.

It has the following steps:

1. **Iterate Through 100 Requests**:
   - A loop sends **100 sequential GET requests** to the endpoint, simulating user activity.

2. **Validate Responses**:
   - Each response is checked to ensure the **status code is 200 (OK)**, indicating successful processing.

3. **Log Response Times**:
   - The time taken for each request is recorded to measure API performance and identify potential bottlenecks.


### Analysis

**Executed, until got Internal Server Error**

**Potential Performance Issues**:

### 1. **High Request Frequency Overloading the Server**
- Sending 100 rapid, back-to-back requests may overwhelm the API server, causing:
  - Errors such as **500 Internal Server Error**.
  - Dropped or delayed requests if the server lacks adequate capacity.

### 2. **Lack of Rate Limiting or Concurrency Management**
- **Rate Limiting**:
  - The test does not consider server-imposed rate limits, which could result in blocked or delayed responses.
- **Concurrency**:
  - Sequential requests fail to simulate realistic scenarios involving multiple users. Concurrency management is essential for effective load testing.

### 3. **Server-Side Resource Constraints**
- Inefficiencies in handling repeated calls to the `/store/inventory` endpoint may arise due to:
  - Poor **database query performance**, leading to slower responses.
  - Lack of **caching** for frequently requested data.
  - Insufficient resource allocation or limited scalability of the server infrastructure.

---

# Rate Limiting Test

The purpose of this test is to simulate a scenario where multiple requests (100 in this case) are sent to the `/user/logout` endpoint to evaluate how the server handles **rate limiting** or **throttling**. The goal is to determine whether the server imposes any limits after a certain number of requests.

1. **Looping Through 100 Requests**:
   - The test sends **100 sequential GET requests** to the `/user/logout` endpoint.
   - The goal is to observe whether the server imposes rate limiting or throttling after a threshold is reached.

2. **Log Response Status**:
   - For each request, the HTTP response status code is logged using `${response.status_code}`.
   - If the server has rate-limiting or throttling mechanisms, we would expect status codes like **429 Too Many Requests** to appear after a certain threshold.


### Analysis

  - The server allowed all **100 requests** to go through without triggering rate limiting or throttling.
  - This indicates that the server did not impose any limits on the `/user/logout` endpoint during this test.

- If all requests return a **200 OK** status, it suggests that:
  - The server did not have rate-limiting mechanisms in place for this endpoint.
  - The API is potentially unprotected against excessive requests, which could lead to server overload under real-world high-traffic scenarios.

- If **429 Too Many Requests** or similar status codes appear:
  - This would indicate that the server is enforcing rate limiting or throttling after a certain number of requests, potentially to avoid overloading.

---

# Spike Testing

The test simulates a **traffic spike** by rapidly sending **500 GET requests** to the `/user/login` endpoint. Each request checks if the response code is **200 (OK)**, indicating successful authentication, and logs the response time to evaluate the system's performance under stress.

### Analysis

- **Request 85**: Response Time = **3.61689 seconds**
- **Request 86**: Response Time = **0.519638 seconds**
- **Request 87**: Response Time = **75.408051 seconds**
- **Request 88**: **Test Failed** (Request could not be processed)

### **Response Time Fluctuations**
- **Request 87** showed a sudden spike in response time (**75.4 seconds**), which is a clear indication of a **performance bottleneck** on the server side.
- Ideally, response times should remain consistent unless the server is overwhelmed. The significant fluctuation points to the server's **inability to scale effectively** under high traffic conditions.
---

# Stress Testing

The **Stress Testing** scenario is designed to **incrementally increase the load** on the `/status` endpoint until the system fails. The test starts with **10 concurrent requests** and progressively increases the load by **50 requests per iteration**, sending a **GET request** for each user's status and measuring the response time. The test continues until failure occurs, helping to identify the system's **breaking point**.


---

### Analysis 

- **Iteration 272**: Response Time = **0.760498 seconds**
- **Iteration 273**: Response Time = **2.495346 seconds**
- **Iteration 274**: Response Time = **12.257862 seconds**
- **Iteration 275**: **Test Failed** (Failure occurred)


### 1. **Response Time Spike**
- There is a significant jump in response time between **Iteration 273** (2.495 seconds) and **Iteration 274** (12.257 seconds).
- This spike suggests a **performance bottleneck** where the server begins to struggle with the increasing load.
- Ideally, the response time should scale proportionally with the load, but the large increase indicates that the system is nearing its **resource limits** and cannot handle the added traffic effectively.

### 2. **Stress Testing Goals Not Met**
- Stress testing aims to push the system to its limits, but the results indicate inefficient handling of increased load beyond a certain threshold.
- The failure at **Iteration 275** points to the server or API's **inability to scale effectively**, suggesting that it cannot manage the growing number of requests efficiently.

---
