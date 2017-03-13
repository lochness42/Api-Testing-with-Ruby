Feature: RESTful API test demonstration
#  a) Get a random user (userID) , print its address to output and verify email format is correct
#  b) Using userID Get their associated posts and verify they contains a valid id, title and body
#  c) Do a post using same userID with a valid title and body

  Scenario: Make an post as a user
    Given I have an user
    And all user's posts' attributes are valid
    When I make a post as an user
    Then post has been successful
