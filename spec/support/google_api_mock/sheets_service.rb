# frozen_string_literal: true

require_relative './auth'

module GoogleApiMock
  class SheetsService
    include Auth

    def initialize(spreadsheet_repo)
      @spreadsheet_repo = spreadsheet_repo
    end

    def get_spreadsheet(id, opts = {})
      @spreadsheet_repo.by_version(id, opts)
    end

    def update_spreadsheet_value(id, range, value_range, _opts = {})
      get_spreadsheet(id, range: range.split('!')[0])
        .sheets[0]
        .update_cells(range.split('!')[1], value_range)
    end

    # def batch_update_spreadsheet(id, opts)
    #   opts = opts.to_h
    #   requests = opts.delete(:requests)
    #   raise 'Check opts' unless opts.empty?

    #   requests.each do |request|
    #     request.each_pair do |action, args|
    #       next if action == :update_sheet_properties

    #       raise 'Check requests'
    #     end
    #   end
    # end
  end
end
