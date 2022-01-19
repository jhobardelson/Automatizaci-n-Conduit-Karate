Feature: Create Token 
Background: precondiciones
    Given url apiUrl

Scenario: Create Token
    And request
    """
        {
            "user": {
                "email": "testCS@gmail.com",
                "password": "123456789"
            }
        }
    """
    And path 'users/login'
    When method Post
    Then status 200
    * def authToken = response.user.token
    * print authToken
