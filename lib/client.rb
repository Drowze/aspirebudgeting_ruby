# frozen_string_literal: true

require 'configuration'

require 'worksheets/backend_data'
require 'worksheets/transactions'
require 'worksheets/category_transfers'

require 'models/transaction'

module AspireBudget
  class Client
    def insert_transaction(params)
      transaction = Models::Transaction.new(params)
      transactions.insert(transaction)
    end

    def insert_category_transfer(params)
      category_transfer = Models::CategoryTransfer.new(params)
      category_transfers.insert(category_transfer)
    end

    private

    def category_transfers
      @category_transfers ||= Worksheets::CategoryTransfers.new
    end

    def transactions
      @transactions ||= Worksheets::Transactions.new
    end

    def backend_data
      @backend_data ||= Worksheets::BackendData.new
    end
  end
end
