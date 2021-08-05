Feature: Test Some Requests From Mock API

  @env=e2e
  Scenario: Test a get call
    Given url 'https://reqres.in/api/users?page=2'
    When method GET
    Then status 200
    And print response
