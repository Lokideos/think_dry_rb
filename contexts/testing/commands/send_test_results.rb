require 'dry/monads/do'

module Testing
  module Commands
    class SendTestResults
      include Dry::Monads[:result]
      include Dry::Monads::Do.for(:call)

      include Import[account_repo: 'contexts.testing.repositories.account',
                     toys_repo: 'contexts.testing.repositories.toy']

      def call(account_id:, toy_id:)
        result = yield find_toy_with_characteristics(account_id, toy_id)
        yield validate_toy(result[:toy])
        yield test_toy(result[:toy])
        result = yield send_event(result)

        Success(account: result[:account], toy: result[:toy])
      end

      private

      def send_event(result)
        json = <<~JSON
        {
          "account_id": "#{result[:account].id}",
          "toy_id": "#{result[:toy].id}",
          "characteristics": [
            {
              "caracteristic_type": "#{result[:characteristics].characteristic_type}",
              "value": "#{result[:characteristics].value}",
              "comment": "#{result[:characteristics].comment}",
              "will_recommend": "#{result[:characteristics].will_recommend}"
            }
          ]
        }
        JSON

        pp json
        Success(account: result[:account], toy: result[:toy])
      end

      def test_toy(toy)
        toy = toys_repo.update_toy_tested_status(toy.id, true)

        Success(toy: toy)
      end

      def validate_toy(toy)
        return Failure([:toy_already_tested, { toy_id: toy.id, toy: toy }]) if toy.tested

        Success(toy: toy)
      end

      def find_toy_with_characteristics(account_id, toy_id)
        account = account_repo.find(account_id)
        toy, characteristics = toys_repo.find_with_characteristics(toy_id)

        if account && toy && characteristics
          Success(account: account, toy: toy, characteristics: characteristics)
        else
          Failure(
            [
              :toy_with_characteristics_not_found,
              {
                account_id: account_id,
                account: account,
                toy_id: toy_id,
                toy: toy,
                toy_characteristics: characteristics
              }
            ]
          )
        end
      end
    end
  end
end
