Feature: Test Soap Examples

  Scenario: Test calculator example
    Given url 'http://www.dneonline.com/calculator.asmx'
    And request
        """
    <?xml version="1.0" encoding="utf-8"?>
    <soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">
      <soap:Body>
        <Add xmlns="http://tempuri.org/">
          <intA>2</intA>
          <intB>3</intB>
        </Add>
      </soap:Body>
    </soap:Envelope>
    """
    When soap action 'http://tempuri.org/Add'
    Then status 200
    And match /Envelope/Body/AddResponse/AddResult == '5'
    And print 'response: ', response

  Scenario: Test Calculator example with xml file
    Given url 'http://www.dneonline.com/calculator.asmx'
    And request read('./data/soapCalRequest.xml')
    # soap is just an HTTP POST, so here we set the required header manually ..
    And header Content-Type = 'text/xml'
    # .. and then we use the 'method keyword' instead of 'soap action'
    When method post
    Then status 200
    # note how we focus only on the relevant part of the payload and read expected XML from a file
    And match /Envelope/Body/AddResponse/AddResult == '50'
    And match response == read('./data/soapCalResponse.xml')


  Scenario: Test post request in xml response
    Given url 'http://postman-echo.com/post'
    And request read('./data/samplePostRequest.xml')
    And header Content-Type = 'application/xml'
    When method post
    Then status 200
    And print response
    And match response.headers["content-type"] =='application/xml; charset=UTF-8'
    # And match response.data == ""

  Scenario: Test post request in xml response
    Given url 'https://reqbin.com/echo/post/xml'
    And header Content-Type = 'application/xml'
    When method post
    Then status 200
    And print response
    # check failure
    And match /Response/ResponseMessage == 'Successs'
