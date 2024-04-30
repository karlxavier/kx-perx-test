class IssuingRulesSeeds
  POINT_RULES = [
    {
      conditions: [
        {
          field: 'currency',
          operator: '==',
          value: '$'
        }
      ],
      calculations: [
        {
          field: 'amount',
          operator: '/',
          value: 10
        }
      ]
    },
    {
      conditions: [
        {
          field: 'currency',
          operator: '!=',
          value: '$'
        }
      ],
      calculations: [
        {
          field: 'amount',
          operator: '/',
          value: 5
        }
      ]
    }
  ]

  REWARDS = [
    {
      code: 'points100',
      name: 'Free 100 Points'
    },
    {
      code: 'coffee',
      name: 'Free Coffee'
    },
    {
      code: 'rebate',
      name: '5% Cash Rebate'
    },
    {
      code: 'movie',
      name: 'Free Movie Tickets'
    },
    {
      code: 'airport',
      name: '4x Airport Lounge Access'
    }
  ]

  REWARD_RULES = [
    {
      conditions: [
        {
          scoped: 'table[:created_at].gteq(Time.now.beginning_of_month).and(table[:created_at].lteq(Time.now.end_of_month))',
          operator: '>=',
          values: ['sum', :current_points],
          should: '100',
          table: 'PointTransaction'
        }
      ],
      reward: -> { Reward.points100.first }
    },
    {
      conditions: [
        {
          scoped: nil,
          operator: '==',
          values: {
            caller: 'birthday',
            extractor: 'month'
          },
          should: 'Time.now.utc.month',
          table: 'User'
        }
      ],
      reward: -> { Reward.coffee.first }
    },
    {
      conditions: [
        {
          scoped: nil,
          operator: '>=',
          values: {
            caller: 'count',
            extractor: 'to_i'
          },
          should: '10',
          table: 'Transaction'
        },
        {
          scoped: nil,
          operator: '>=',
          values: ['sum', :amount],
          should: '100',
          table: 'Transaction'
        }
      ],
      reward: -> { Reward.rebate.first }
    },
    {
      conditions: [
        {
          scoped: 'table[:created_at].gteq(60.days.ago.utc).and(table[:created_at].lteq(Time.now.utc))',
          operator: '>=',
          values: ['sum', :amount],
          should: '1000',
          table: 'Transaction'
        }
      ],
      reward: -> { Reward.movie.first }
    }
  ]
  
  class << self
    def rewards_seeds
      REWARDS.each do |reward|
        Reward.create!(reward)
      end
    end

    def points_rule_seeds
      POINT_RULES.each do |rules|
        PointsIssuingRule.create!(rules)
      end
    end

    def rewards_rule_seeds
      REWARD_RULES.each do |rules|
        RewardsIssuingRule.create!(
          conditions: rules[:conditions],
          reward: rules[:reward].call
        )
      end
    end
  end
end
