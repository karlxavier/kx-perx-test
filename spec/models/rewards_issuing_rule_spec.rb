require 'rails_helper'

RSpec.describe RewardsIssuingRule, type: :model do
  describe 'associations' do
    it { is_expected.to belong_to(:reward) }
    it { is_expected.to have_many(:reward_transactions) }
  end
end
