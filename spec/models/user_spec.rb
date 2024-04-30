require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'associations' do
    it { is_expected.to have_many(:transactions) }
    it { is_expected.to have_many(:point_transactions) }
    it { is_expected.to have_many(:reward_transactions) }
  end

  describe 'loyalty_tier' do
    let(:user) { create(:user) }
    let(:amount) { 400 }
    let(:transactions) { build_list(:transaction, 4, user:, amount: amount) }

    before do
      Sidekiq::Testing.inline! do
        transactions.each(&:save)
      end
    end

    context 'when user points is less than gold points' do
      it 'sets to standard tier' do
        expect(user.reload.standard?).to be true
      end
    end

    context 'when user points is greater or equal to gold points' do
      let(:amount) { 3000 }

      it 'sets to gold tier' do
        expect(user.reload.gold?).to be true
      end
    end

    context 'when user points is greater or equal to platinum points' do
      let(:amount) { 8000 }

      it 'sets to gold tier' do
        expect(user.reload.gold?).to be true
      end
    end
  end
end