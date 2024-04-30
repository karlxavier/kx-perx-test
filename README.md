# README

This is Karl Xavier del Campo technical test for Perx

RSpec Tests

* `spec/models/transaction_spec.rb`
  - Once new record has been created it will run `CalculatePointsWorker` to calculate and update User points.
  - Points criteria are all stored in `PointsIssuingRule` table.

* `spec/workers/calculate_rewards_worker_spec.rb`
  - `CalculateRewardsWorker` is to calculate and issue rewards to users who met the reward conditions.
  - Reward conditions are all stored in `RewardsIssuingRule`
 
* Please also check the `IssuingRulesSeeds` in `spec/support` which have all the rules and conditions for Points and Rewards.
