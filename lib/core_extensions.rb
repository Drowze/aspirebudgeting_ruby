# frozen_string_literal: true

require 'google_drive'

module AspireBudget
  module CoreExtensions
    module Worksheet
      def rows(skip = 0, cell_method: :[])
        nc = num_cols
        result = ((1 + skip)..num_rows).map do |row|
          (1..nc).map { |col| send(cell_method, row, col) }.freeze
        end
        result.freeze
      end
    end
  end
end

# https://github.com/gimite/google-drive-ruby/issues/378
GoogleDrive::Worksheet.prepend AspireBudget::CoreExtensions::Worksheet
