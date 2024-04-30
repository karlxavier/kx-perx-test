require 'rails_helper'

RSpec.describe PointTransaction, type: :model do
  describe 'associations' do
    it { is_expected.to belong_to(:loyalty_rule) }
    it { is_expected.to belong_to(:user_transaction).class_name('Transaction') }
  end

  describe '#calculate' do
    let(:user) { create(:user) }
    let(:points_issuing_rule) {  }
    let(:transactions) { build_list(:transaction, 2, user:, amount: 1200) }

    context 'when user accumulates 100 points in one calendar month' do
      it 'rewards free coffee' do
        Sidekiq::Testing.inline! do
          transactions.each(&:save)
        end
        byebug
        # point_transaction = transaction.reload.point_transaction
      end
    end
  end
end
