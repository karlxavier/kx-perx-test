class CalculateRewardsWorker
  include Sidekiq::Worker

  def perform
    User.all.each do |user|
      Loyalty::Rewards::Issuer.new(user:).call
    end
  end
end
