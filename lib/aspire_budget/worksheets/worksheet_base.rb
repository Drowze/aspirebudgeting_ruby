# frozen_string_literal: true

require_relative '../configuration'
require_relative '../utils'

module AspireBudget
  module Worksheets
    # @abstract Subclass and reimplement ws_title to implement a custom
    #   worksheet
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

      # @see AspireBudget::Configuration#agent
      # @return a new instance of the calling class configured with an agent
      # @param session [GoogleDrive::Session]
      # @param spreadsheet_key [String] spreadsheet key as per its url
      def initialize(session: nil, spreadsheet_key: nil)
        @session = session
        @spreadsheet_key = spreadsheet_key
        @agent = AspireBudget.configuration.agent(@session, @spreadsheet_key)
      end

      # @return [Boolean] Whether the worksheet has unsaved changes
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
