# frozen_string_literal: true

require 'configuration'
require 'utils'

module AspireBudget
  module Worksheets
    class WorksheetBase
      include Utils

      class << self
        def instance
          @instance ||= new
        end

        private

        def method_missing(method_name, *args, &block)
          if instance.respond_to?(method_name)
            instance.public_send(method_name, *args, &block)
          else
            super
          end
        end

        def respond_to_missing?(method_name, include_private = false)
          instance.respond_to?(method_name) || super
        end
      end

      def initialize(session: nil, spreadsheet_key: nil)
        @agent = AspireBudget.configuration.agent(session, spreadsheet_key)
      end

      def dirty?
        ws.dirty?
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
