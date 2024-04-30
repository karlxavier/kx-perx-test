require 'rails_helper'

RSpec.describe RewardTransaction, type: :model do
  describe 'associations' do
    it { is_expected.to belong_to(:rewards_issuing_rule) }
    it { is_expected.to belong_to(:rewardable) }
    it { is_expected.to belong_to(:user) }
  end
end
