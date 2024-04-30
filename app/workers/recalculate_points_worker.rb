class RecalculatePointsWorker
  include Sidekiq::Worker

  def perform(transaction_id)
    transaction = Transaction.find_by_id(transaction_id)
    Loyalty::Points::Issuer.new(transaction:).call
  end
end
