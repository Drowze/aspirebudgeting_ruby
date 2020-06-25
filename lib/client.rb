# frozen_string_literal: true

require 'worksheets/backend_data'
require 'worksheets/transactions'

require 'models/transaction'

module AspireBudgetWrapper
  class Client
    def initialize(session:, spreadsheet_key:)
      @session = session
      @spreadsheet_key = spreadsheet_key
    end

    def categories
      backend_data.categories
    end

    def transaction_list
      transactions.all
    end

    def insert_transaction(params)
      transaction = Models::Transaction.new(params)
      transactions.insert(transaction)
    end

    private

    def transactions
      @transactions ||= Worksheets::Transactions.new(agent: agent)
    end

    def backend_data
      @backend_data ||= Worksheets::BackendData.new(agent: agent)
    end

    def agent
      @agent ||= begin
        @session.spreadsheet_by_key(@spreadsheet_key)
      end
    end
  end
end
