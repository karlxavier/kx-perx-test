require 'rails_helper'

RSpec.describe CalculateRewardsWorker, type: :worker do
  describe '#perform' do
    subject(:calculate_rewards) do
      Sidekiq::Testing.inline! do
        CalculateRewardsWorker.perform_async
      end
    end

    let(:user_birthday) { 2.months.ago }
    let(:create_count) { 2 }
    let(:user) { create(:user, birthday: user_birthday) }
    let(:amount) { 400 }
    let(:transactions) { build_list(:transaction, create_count, user:, amount: amount) }

    before do
      Sidekiq::Testing.inline! do
        transactions.each(&:save)
      end
    end

    context 'when user dont have enough points' do
      it 'denies user reward' do
        expect { calculate_rewards }.not_to change(user.reload.reward_transactions, :count)
      end
    end

    shared_examples_for 'rewarding user' do
      it 'rewards user' do
        reward_transactions = user.reload.reward_transactions

        expect(reward_transactions.map(&:rewardable)).to include(user_reward)
      end
    end

    describe 'Rewarding User' do

      before { calculate_rewards }

      context 'when Free 100 points' do
        context 'when user have enough points' do
          let(:user_reward) { Reward.points100.first }
          let(:amount) { 600 }

          it_behaves_like 'rewarding user'
        end
      end
      
      context "when user's birthmonth" do
        let(:user_reward) { Reward.coffee.first }
        let(:user_birthday) { 1.year.ago }
        let(:amount) { 200 }

        it_behaves_like 'rewarding user'
      end

      context 'when 5% Cash Rebate' do
        context 'when user have enough points' do
          let(:user_reward) { Reward.rebate.first }
          let(:create_count) { 11 }
          let(:amount) { 10 }

          it_behaves_like 'rewarding user'
        end
      end

      context 'when 5% Cash Rebate' do
        context 'when user have enough points' do
          let(:user_reward) { Reward.movie.first }
          let(:amount) { 600 }

          before do
            transactions.first.update(created_at: 65.days.ago)
          end

          it_behaves_like 'rewarding user'
        end
      end
    end
  end
end
