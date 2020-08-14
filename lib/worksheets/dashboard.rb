# frozen_string_literal: true

require 'worksheets/worksheet_base'

module AspireBudget
  module Worksheets
    class Dashboard < WorksheetBase
      WS_TITLE = 'Dashboard'

      CELL_MAP_3_2_0 = {
        available_to_budget: 'H2',
        spent_this_month: 'I2',
        budgeted_this_month: 'K2',
        pending_transactions: 'O2'
      }.freeze

      CELL_MAP_3_1_0 = {
        available_to_budget: 'C5',
        spent_this_month: 'C6',
        pending_transactions: 'C7'
      }.freeze

      IMMEDIATE_METHODS = (CELL_MAP_3_2_0.keys | CELL_MAP_3_1_0.keys)

      private_constant :IMMEDIATE_METHODS

      IMMEDIATE_METHODS.each do |data_name|
        define_method data_name do
          cell = cell_map[data_name] || raise("#{data_name} is not supported on #{spreadsheet_version}")
          ws.numeric_value(cell)
        end
      end

      private

      def cell_map
        case spreadsheet_version
        when '3.2.0' then CELL_MAP_3_2_0
        when '3.1.0' then CELL_MAP_3_1_0
        else raise "version #{version} not supported"
        end
      end

      def ws_title
        'Dashboard'
      end
    end
  end
end
