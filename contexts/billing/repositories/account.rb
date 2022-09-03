module Billing
  module Repositories
    class Account < ROM::Repository[:accounts]
      include Import[container: 'persistence']

      struct_namespace Billing::Entities

      def all
        root.to_a
      end

      def find(id)
        root.by_pk(id).one
      end

      def increase_balance(id, balance_increase)
        current_balance = root.by_pk(id).one.balance
        root.by_pk(id).update(balance: current_balance + balance_increase)
        root.by_pk(id).one
      end
    end
  end
end
