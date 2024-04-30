require 'rails_helper'

RSpec.describe Transaction, type: :model do
  describe 'associations' do
    it { is_expected.to belong_to(:user) }
    it { is_expected.to have_one(:point_transaction) }
  end

  let(:amount) { 100 }
  let(:currency) { '$' }

  describe '#calculate' do
    let(:transaction) { build(:transaction, amount:, currency:) }

    shared_examples_for 'calculating loyalty points' do |points|
      it 'calculates to correct loyalty rule' do
        Sidekiq::Testing.inline! do
          transaction.save
        end
        point_transaction = transaction.reload.point_transaction

        expect(transaction.reload.calculated?).to be true
        expect(point_transaction.available?).to be true
        expect(point_transaction.total_points).to eq(points)
        expect(point_transaction.current_points).to eq(points)
      end
    end

    context 'when transaction currency is in $' do
      it_behaves_like 'calculating loyalty points', 10
    end

    context 'when transaction currency is not in $' do
      let(:currency) { '£' }

      it_behaves_like 'calculating loyalty points', 20
    end

    context 'when amount is less than 100' do
      let(:amount) { 50 }

      it_behaves_like 'calculating loyalty points', 5
    end
  end

  describe '#recalculate' do
    let(:transaction) { create(:transaction, amount:, currency:) }

    context 'when points are available' do
      it 'recalculates loyalty points' do
        Sidekiq::Testing.inline! do
          transaction.update(amount: 200)

          point_transaction = transaction.reload.point_transaction

          expect(transaction.reload.calculated?).to be true
          expect(point_transaction.available?).to be true
          expect(point_transaction.total_points).to eq(20)
          expect(point_transaction.current_points).to eq(20)
        end
      end
    end

    context 'when points are used' do
      it 'raises CalculationError' do
        Sidekiq::Testing.inline! do
          point_transaction = transaction.reload.point_transaction
          point_transaction.use!

          expect { transaction.update(amount: 200) }.to raise_error(Loyalty::Points::Issuer::PointsIssuanceError)
        end
      end
    end
  end
end
