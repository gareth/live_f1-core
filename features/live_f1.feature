Feature: Live timing connection
  In order to follow a Formula 1 race live
  As a user of the LiveF1 library
  I want to receive packets of data

  Scenario: Connecting before the session has started
    Given the live timing session is about to start
    When I successfully connect to the live timing service
    Then I should receive packets of data

  Scenario: Connecting after the session has completed
    Given the live timing session has been completed
    When I successfully connect to the live timing service
    Then I should receive packets of data
