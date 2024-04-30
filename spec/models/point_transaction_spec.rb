require 'rails_helper'

RSpec.describe PointTransaction, type: :model do
  describe 'associations' do
    it { is_expected.to belong_to(:points_issuing_rule) }
    it { is_expected.to belong_to(:user) }
  end
end
