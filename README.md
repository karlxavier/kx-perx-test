# README

This is Karl Xavier del Campo technical test for Perx

RSpec Tests

* `spec/models/transaction_spec.rb`
  - Upon the creation of each new transaction, the system triggers the `CalculatePointsWorker` worker, which is responsible for computing and updating the points associated with the user.
  - The rules and conditions governing user points are stored within the `PointsIssuingRule` table.

* `spec/workers/calculate_rewards_worker_spec.rb`
  - The purpose of the `CalculateRewardsWorker` is to assess whether users meet the criteria for receiving rewards and, if so, to issue those rewards accordingly.
  - The rules and conditions governing user rewards are stored within the `RewardsIssuingRule` table.
 
* Additionally, please review the `IssuingRulesSeeds` located in spec/support, where you can find comprehensive sets of rules and conditions governing both points and rewards.
