# frozen_string_literal: true

require 'aspire_budget_wrapper/worksheets/backend_data'

module AspireBudgetWrapper
  class Client
    def initialize(session:, spreadsheet_key:)
      @session = session
      @spreadsheet_key = spreadsheet_key
    end

    def agent
      @agent ||= begin
        @session.spreadsheet_by_key(@spreadsheet_key)
      end
    end

    def categories
      Worksheets::BackendData.new(agent: agent).categories
    end
  end
end
