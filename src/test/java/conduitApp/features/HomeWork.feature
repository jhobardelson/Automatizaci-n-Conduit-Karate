Feature: Home Page Favorite Articles
Background: precondiciones
    #LLamado de url base
    Given url apiUrl

    #Llamado de token
    * def TokenResponse = callonce read('classpath:helpers/createToken.feature')
    * def token = TokenResponse.authToken

    # Validacion de tiempo
    * def timeValidator = read('classpath:helpers/time-validation.js')
    
    # Step 1: Get atricles of the global feed
    * def SlugArticle = callonce read('classpath:helpers/getSlug.feature')

    # Step 2: Get the favorites count and slug ID for the first arice, save it to variables
    * def slugID = SlugArticle.slugID

    #Llamado de requestBody para nuevo comentario
    * def requestBodyNewComment = read('classpath:conduitApp/JSON/reqeuestBodyNewComment.json')
    * def dataGenerator = Java.type('helpers.DataGenerate')
    * set requestBodyNewComment.comment.body = dataGenerator.getRandomComment().body


Scenario: Favorite articles
    
    # # Step 1: Get atricles of the global feed
    Given path 'articles'
    And params {limit: 10, offset: 0}
    And header Authorization = 'Token ' + token
    When method Get
    Then status 200

    # Step 2: Get the favorites count and slug ID for the first arice, save it to variables
    * print slugID

    # Step 3: Make POST request to increse favorites count for the first article
    * if ( response.articles[0].favorited == 'true' ) karate.call('src\test\java\helpers\DeleteFavorite.feature')
    Given path 'articles/' + slugID + '/favorite'
    And header Authorization = 'Token ' + token
    When method Post
    Then status 200
    
    # Step 4: Verify response schema
    And match response.article ==  
        """
        {
            "id": "#number",
            "slug": "#string",
            "title": "#string",
            "description": "#string",
            "body": "#string",
            "createdAt": "#? timeValidator(_)",
            "updatedAt": "#? timeValidator(_)",
            "authorId": "#number",
            "tagList": "#array",
            "author": {
                "username": "#string",
                "bio": "##string",
                "image": "#string",
                "following": "#boolean"
            },
            "favoritedBy": "#array",
            "favorited": "#boolean",
            "favoritesCount": "#number"
        }
        """

    # Step 5: Verify that favorites article incremented by 1
    * def initialCount = 0
    * def response = {"favoritesCount": 1}
    * match response.favoritesCount == initialCount + 1
    
    # Step 6: Get all favorite articles
    Given path 'articles'
    And params {favorited:JhobarZg, limit:10, offset:0}
    And header Authorization = 'Token ' + token
    When method Get 
    Then status 200

    # Step 7: Verify response schema
    And match each response.articles ==  
        """
        {
            "slug": "#string",
            "title": "#string",
            "description": "#string",
            "body": "#string",
            "createdAt": "#? timeValidator(_)",
            "updatedAt": "#? timeValidator(_)",
            "tagList": "#array",
            "author": {
                "username": "#string",
                "bio": "##string",
                "image": "#string",
                "following": "#boolean"
            },
            "favoritesCount": "#number",
            "favorited": "#boolean"
        }
        """

    # Step 8: Verify that slug ID from Step 2 exist in one of the favorite articles
    And match response..slug contains slugID

    # Step 9: Delete Favorite
      Given path 'articles/' + slugID + '/favorite'
      And header Authorization = 'Token ' + token
      When method Delete
      Then status 200



Scenario: Comment articles
    ##Se cumple en el Background
     # Step 1: Get atricles of the global feed


    # Step 2: Get the favorites count and slug ID for the first arice, save it to variables
    * print slugID

    # Step 3: Make a GET call to 'comments' end-point to get all comments
    Given path 'articles/' + slugID + '/comments'
    And header Authorization = 'Token ' + token
    When method Get
    Then status 200

    # Step 4: Verify response schema
    And match each response.comments == 
        """
        {
            "id": "#number",
            "createdAt": "#? timeValidator(_)",
            "updatedAt": "#? timeValidator(_)",
            "body": "#string",
            "author": {
                "username": "#string",
                "bio": "##string",
                "image": "#string",
                "following": "#boolean"
            }
        }  
        """

    # Step 5: Get the count of the comments array lentgh and save to variable
    * def responseWithComments = response.comments
    * def commentsCount = responseWithComments.length

    # Step 6: Make a POST request to publish a new comment
    Given path 'articles/' + slugID + '/comments'
    And header Authorization = 'Token ' + token
    And request requestBodyNewComment
    When method Post
    Then status 200
    * print response

    # Step 7: Verify response schema that should contain posted comment text
    And match response.comment == 
        """
        {
            "id": "#number",
            "createdAt": "#? timeValidator(_)",
            "updatedAt": "#? timeValidator(_)",
            "body": "#string",
            "author": {
                "username": "#string",
                "bio": "##string",
                "image": "#string",
                "following": "#boolean"
            }
        }
        """

    # Step 8: Get the list of all comments for this article one more time
    Given path 'articles/' + slugID + '/comments'
    And header Authorization = 'Token ' + token
    When method Get
    Then status 200
    * def IdComment = response.comments[0].id
    

    # Step 9: Verify number of comments increased by 1 (similar like we did with favorite counts)
    * def responseWithComments = response.comments
    * def commentsCountIncreased = responseWithComments.length
    And match commentsCountIncreased == commentsCount + 1

  

    # Step 10: Make a DELETE request to delete comment
    * print IdComment
    Given path 'articles/' + slugID + '/comments/' + IdComment
    And header Authorization = 'Token ' + token
    When method Delete 
    Then status 204

    # Step 11: Get all comments again and verify number of comments decreased by 1
    Given path 'articles/' + slugID + '/comments'
    And header Authorization = 'Token ' + token
    When method Get
    Then status 200
    * def responseWithComments = response.comments
    * def commentsCountDecremented = responseWithComments.length

    And match commentsCountDecremented == commentsCountIncreased - 1

    




   
    


    



