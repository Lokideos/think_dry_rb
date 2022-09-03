module Billing
  module Repositories
    class TestResult < ROM::Repository[:test_results]
      include Import[container: 'persistence']

      struct_namespace Billing::Entities

      def all
        root.to_a
      end

      def find(id)
        root.by_pk(id).one
      end

      def find_by_account(account_id)
        root.where(account_id: account_id)
      end
    end
  end
end
