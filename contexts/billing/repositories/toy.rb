module Billing
  module Repositories
    class Toy < ROM::Repository[:toys]
      include Import[container: 'persistence']

      struct_namespace Billing::Entities

      def all
        root.to_a
      end

      def find(id)
        root.by_pk(id).one
      end
    end
  end
end
