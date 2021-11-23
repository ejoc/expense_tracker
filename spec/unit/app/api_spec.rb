require 'rack/test'
require_relative '../../../app/api'

module ExpenseTracker
  RSpec.describe API do
    include Rack::Test::Methods

    let(:ledger) { instance_double('ExpenseTracker::Ledger') }
    # let(:app) { API.new(ledger: ledger) }
    def app
      API.new(ledger: ledger)
    end

    describe 'POST /expenses' do
      context 'when the expense is successfully recorded' do
        let(:expense) { {'some' => 'data'} }
        before do
          allow(ledger).to receive(:record)
            .with(expense)
            .and_return(RecordResult.new(true, 417, nil))
        end
        it 'returns the expense id' do
          post '/expenses', JSON.generate(expense)

          parsed = JSON.parse(last_response.body)
          expect(parsed).to include('expense_id' => 417)
        end

        it 'responds with a 200 (OK)' do
          post '/expenses', JSON.generate(expense)
          expect(last_response.status).to eq(200)
        end
      end

      # the context will go here

      context 'when the expense fails validation' do
        let(:expense) { {'some' => 'data'} }

        before do
          allow(ledger).to receive(:record)
            .with(expense)
            .and_return(RecordResult.new(false, 417, 'Expense Incomplete'))
        end
        it 'returns an error message' do
          post '/expenses', JSON.generate(expense)

          parsed = JSON.parse(last_response.body)
          expect(parsed).to include('error' => 'Expense Incomplete')
        end

        it 'response with a 422 (Unprocessable entity)' do
          post '/expenses', JSON.generate(expense)
          expect(last_response.status).to eq(422)
        end
      end
    end

    describe('GET /expense/:date') do
      context 'when expenses exist on the given date' do
        it 'returns the expense records as JSON'
        it 'responds with a 200 (OK)'
      end

      context 'when there are no expenses on the given date' do
        it 'returns an empty array as JSON'
        it 'responds with a 200 (OK)'
      end
    end
  end
end