Feature: Command line utility
  In order to easily control everything about Spectate
  As a user
  I want to call "spectate" from the command line

  Scenario: Usage help
    When I execute "spectate --help"
    Then I should see "Usage:"

	Scenario: Basic startup
		Given no Spectate is running
		When I execute "spectate"
		Then I should see "Starting Spectate"

	