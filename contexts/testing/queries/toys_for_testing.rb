module Testing
  module Queries
    class ToysForTesting
      include Dry::Monads[:result]

      include Import[account_repo: 'contexts.testing.repositories.account',
                     toys_repo: 'contexts.testing.repositories.toy']

      def call(account_id:)
        account = account_repo.find(account_id)
        return Failure[:account_not_found, { account_id: account_id }] if account.nil?

        toys = toys_repo.find_not_tested_for_account(account_id)

        Success(toys: toys)
      end
    end
  end
end
