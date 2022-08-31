module InMemory
  module Transport
    class BillingRequest
      include Import[service: 'contexts.billing.service']

      def call
        puts 'Hello from in_memory billing request'
        puts 'Call logic:'
        puts
        sleep 0.5

        service.call

        puts
        sleep 0.5
        puts 'Request done'
      end
    end
  end
end
