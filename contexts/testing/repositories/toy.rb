module Testing
  module Repositories
    class Toy < ROM::Repository[:toys]
      include Import[container: 'persistence']

      struct_namespace Testing::Entities

      def all
        root.to_a
      end

      def find(id)
        root.by_pk(id).one
      end

      def find_for_account(account_id)
        root.where(account_id: account_id).to_a
      end

      def find_not_tested_for_account(account_id)
        root.where(account_id: account_id, tested: false).to_a
      end

      def assign_account(account_id, toy_id)
        root.by_pk(toy_id).update(account_id: account_id)
        find(toy_id)
      end
    end
  end
end
