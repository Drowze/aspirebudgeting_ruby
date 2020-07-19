# frozen_string_literal: true

require 'worksheets/worksheet_base'
require 'worksheets/transactions'
require 'models/category_transfer'

module AspireBudget
  module Worksheets
    class CategoryTransfers < Transactions
      WS_TITLE = 'Category Transfers'

      private

      def klass
        Models::CategoryTransfer
      end

      def header
        @header ||=
          super.map { |k| k == :'from category' ? :from : k }
               .map { |k| k == :'to category' ? :to : k }[0...-1]
      end
    end
  end
end
