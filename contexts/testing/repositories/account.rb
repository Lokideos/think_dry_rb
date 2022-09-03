module Testing
  module Repositories
    class Account < ROM::Repository[:accounts]
      include Import[container: 'persistence']

      struct_namespace Testing::Entities

      def all
        root.to_a
      end

      def find(id)
        root.by_pk(id).one
      end
    end
  end
end
