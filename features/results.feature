Feature: Result Analyzer Daily Activity

  Background:
    Given the system has the following daily result stats:
      | date        | subject   | daily_low  | daily_high  | result_count  |
      | 2022-04-07  | Science   | 124.30     | 125.58      | 12            |
      | 2022-04-08  | Science   | 123.73     | 127.23      | 11            |
      | 2022-04-11  | Science   | 121.12     | 124.52      | 12            |
      | 2022-04-12  | Science   | 117.22     | 120.11      | 81            |
      | 2022-04-13  | Science   | 118.84     | 119.29      | 22            |
      | 2022-04-14  | Science   | 120.27     | 123.33      | 57            |
      | 2022-04-15  | Science   | 126.01     | 128.77      | 23            |
      | 2022-04-18  | Science   | 119.88     | 126.76      | 5             |

  Scenario: Receive and process test results
    Given today is "2022-04-18"
    When MSM submits the following results:
      | subject | timestamp            | marks |
      | Science | 2022-04-18 12:02:44  | 123.54 |
      | Science | 2022-04-18 13:37:26  | 120.99 |
      | Science | 2022-04-18 15:33:23  | 126.76 |
      | Science | 2022-04-18 17:21:55  | 119.88 |
      | Science | 2022-04-18 17:47:27  | 125.21 |
    Then the daily result stats for "2022-04-18" should be:
      | date        | subject   | daily_low  | daily_high  | result_count  |
      | 2022-04-18  | Science   | 119.88     | 126.76      | 5             |

  Scenario: Calculate monthly averages
    Given today is "2022-04-18"
    When the system calculates monthly averages
    Then the monthly averages for "2022-04-18" should be:
      | date        | subject   | monthly_avg_low  | monthly_avg_high  | monthly_result_count_used |
      | 2022-04-18  | Science   | 120.56           | 123.8             | 200                       |