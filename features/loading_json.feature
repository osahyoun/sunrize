Feature: User Data
  In order to do interesting things with my account data
  As a memrise user
  I want to have access to my stats as a JSON encoded object

Scenario: Non-existing user on sunrize
  Given "MonkeyKing" is not on sunrize
  When "MonkeyKing" request their data
  Then "MonkeyKing" should get a not found object

Scenario: Non-existing user on memrize
  Given user is not on memrise
  Then user should get a sorry message
  # When "MonkeyKing" request their data
  # Then "MonkeyKing" should get a not found object

Scenario: Fetching User
  Given "MonkeyKing" is not on sunrize
  When "MonkeyKing" registers
  And "MonkeyKing" request their data
  Then "MonkeyKing" should get a JSON encoded object of their usage stats

Scenario: Existing user with no rank
  Given a user has no ranking yet
  Then JSON should encode this as null