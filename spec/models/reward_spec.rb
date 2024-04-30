require 'rails_helper'

RSpec.describe Reward, type: :model do
  describe 'associations' do
    it { is_expected.to have_many(:reward_transactions) }
  end
end
