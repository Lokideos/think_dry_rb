require 'dry/monads/do'

module Testing
  module Commands
    class TestToy
      include Dry::Monads[:result]
      include Dry::Monads::Do.for(:call)

      include Import[account_repo: 'contexts.testing.repositories.account',
                     toys_repo: 'contexts.testing.repositories.toy']

      def call(account_id:, toy_id:)
        result = yield find_account_and_toy(account_id, toy_id)
        yield validate_account_toys(result[:account], result[:account_toys])
        toy = assign_toy_to_account(account_id, toy_id)

        Success(toy: toy)
      end

      private

      def validate_account_toys(account, account_toys)
        if account_toys.size < 3
          Success(account: account, account_toys: account_toys)
        else
          Failure(
            [
              :account_has_too_many_toys_for_test,
              { account: account, account_toys: account_toys }
            ]
          )
        end
      end

      def assign_toy_to_account(account_id, toy_id)
        toy = toys_repo.assign_account(account_id, toy_id)

        Success(toy: toy)
      end

      def find_account_and_toy(account_id, toy_id)
        account = account_repo.find(account_id)
        account_toys = toys_repo.find_not_tested_for_account(account_id)
        toy = toys_repo.find(toy_id)

        if account && toy
          Success(account: account, toy: toy, account_toys: account_toys)
        else
          Failure(
            [
              :account_and_toy_not_found,
              { account_id: account_id, account: account, toy_id: toy_id, toy: toy }
            ]
          )
        end
      end
    end
  end
end
