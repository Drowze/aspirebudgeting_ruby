# frozen_string_literal: true

require 'configuration'

require 'worksheets/backend_data'
require 'worksheets/transactions'
require 'worksheets/category_transfers'

require 'models/transaction'

module AspireBudget
  class Client
    def insert_category_transfer(params)
      category_transfer = Models::CategoryTransfer.new(params)
      category_transfers.insert(category_transfer)
    end

    private

    def category_transfers
      @category_transfers ||= Worksheets::CategoryTransfers.new
    end
  end
end
