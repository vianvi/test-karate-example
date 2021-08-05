Feature: Add Some More Example Tests

Background:
    * url someUrlBase
    * header Accept = 'application/json'
    * def loginRequestBody = './data/loginRequest.json'
    * def loginResponseBody = './data/loginResponse.json'
    * def updateUserDetailsRequestBody = './data/updateUserDataRequest.json'
    * def updateUserDetailsResponseBody = './data/updateUserDataResponse.json'

  Scenario: Test with Path
    Given path '/users?page=2'
    When method GET
    Then print responseStatus
    And print response
    And status 200

  Scenario: Test with param and assertions
    Given path '/users'
    And param page = 2
    When method GET
    Then print responseStatus
    And print response
    And status 200
    And assert response.data[1].first_name == "Lindsay"
    And match $.data[1].last_name == 'xyz'

  Scenario: Test a login success with request and response json file
    Given path '/login'
    And request read(loginRequestBody)
    When method POST
    Then print responseStatus
    And print response
    And status 200
    And match response == read(loginResponseBody)

  Scenario: Test a login fail for no password
    Given path '/login'
    And def requestBody = read(loginRequestBody)
   # make password empty
    And set requestBody.password = ''
    And print requestBody
    And request requestBody
    When method POST
    Then print responseStatus
    And print response
    And status 200
    And match response == read(loginResponseBody)

  Scenario: Test a update request
    Given path '/users/2'
    And def requestBody = read(updateUserDetailsRequestBody)
    And request requestBody
    When method PUT
    Then print responseStatus
    And print response
    And status 200
    And match response == read(updateUserDetailsResponseBody)
