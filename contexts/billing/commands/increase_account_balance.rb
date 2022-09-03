require 'dry/monads/do'

module Billing
  module Commands
    class IncreaseAccountBalance
      include Dry::Monads[:result]
      include Dry::Monads::Do.for(:call)

      include Import[account_repo: 'contexts.billing.repositories.account',
                     toys_repo: 'contexts.billing.repositories.toy',
                     test_results_repo: 'contexts.billing.repositories.test_result']

      def call(account_id:, toy_id:)
        result = yield find_account_and_toy(account_id, toy_id)
        yield validate_account(result[:account])
        yield validate_test_result(result[:account])

        result = yield increase_account_balance(result[:account])

        Success(account: result[:account])
      end

      private

      def increase_account_balance(account)
        account = account_repo.increase_balance(account.id, 1000)

        Success(account: account)
      end

      def validate_account(account)
        return Failure([:account_blocked, { account_id: account.id, account: account }]) if account.blocked?

        Success(account: account)
      end

      def validate_test_result(account)
        test_result = test_results_repo.find_by_account(account.id)

        if test_result
          Success(account: account)
        else
          Failure(
            [
              :test_result_not_found,
              { account_id: account.id, account: account }
            ]
          )
        end
      end

      def find_account_and_toy(account_id, toy_id)
        account = account_repo.find(account_id)
        toy = toys_repo.find(toy_id)

        if account && toy
          Success(account: account, toy: toy)
        else
          Failure(
            [
              :account_and_toy_not_found,
              {
                account_id: account_id,
                account: account,
                toy_id: toy_id,
                toy: toy
              }
            ]
          )
        end
      end
    end
  end
end
