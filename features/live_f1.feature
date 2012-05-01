Feature: Live timing connection
  In order to follow a Formula 1 race live
  As a user of the LiveF1 library
  I want to receive packets of data

  Scenario: Receive live timing packets
    Given there is a live timing session in progress
    When I successfully connect to the live timing service
    Then I should receive packets of data
