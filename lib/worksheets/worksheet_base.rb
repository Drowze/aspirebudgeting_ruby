# frozen_string_literal: true

require 'utils'

module AspireBudget
  module Worksheets
    class WorksheetBase
      include Utils

      def initialize(agent:)
        @agent = agent
      end

      private

      def ws
        worksheets[self.class::WS_TITLE]
      end

      def worksheets
        @worksheets ||=
          @agent.worksheets.reduce({}) { |h, sheet| h.merge(sheet.title => sheet) }
      end
    end
  end
end
