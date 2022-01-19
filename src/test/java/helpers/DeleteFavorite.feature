Feature: Delete Favorite 
Background: precondiciones 
    Given url apiUrl
    * def TokenResponse = callonce read('createToken.feature')
    * def token = TokenResponse.authToken
    * def SlugId = callonce read('getSlug.feature')
    * def slugDelete = SlugId.slugID

Scenario: Delete Favorite
    Given path 'articles/' + slugDelete + '/favorite'
     And header Authorization = 'Token ' + token
     When method Delete
     Then status 200
     * print response