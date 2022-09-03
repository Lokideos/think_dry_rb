module Billing
  module Entities
    class Account < ROM::Struct
      def blocked?
        !active
      end
    end
  end
end
