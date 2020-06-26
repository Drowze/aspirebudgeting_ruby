# frozen_string_literal: true

require 'worksheets/backend_data'
require 'worksheets/transactions'
require 'worksheets/category_transfers'

require 'models/transaction'

module AspireBudget
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

    def category_transfer_list
      category_transfers.all
    end

    def insert_category_transfer
      category_transfer = Models::CategoryTransfer.new(params)
      category_transfers.insert(category_transfer)
    end

    private

    def category_transfers
      @category_transfers ||= Worksheets::CategoryTransfers.new(agent: agent)
    end

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
