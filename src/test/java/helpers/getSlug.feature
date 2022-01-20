Feature: Get Slug
Background: precondiciones
    Given url apiUrl
    * def TokenResponse = callonce read('classpath:helpers/createToken.feature')
    * def token = TokenResponse.authToken
    

Scenario: Get Slug
    Given path 'articles'
    And params {limit: 10, offset: 0}
    And header Authorization = 'Token ' + token
    When method Get
    Then status 200
    * def slugID = response.articles[0].slug