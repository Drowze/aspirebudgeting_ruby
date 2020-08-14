# frozen_string_literal: true

require 'configuration'
require 'utils'

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

      # Initializes the worksheet. To use the spreadsheet default
      # +session+ / +spreadsheet_key+, just initialize without arguments.
      # @param session [GoogleDrive::Session]
      # @param spreadsheet_key [String] spreadsheet key as per its url
      # @param agent [GoogleDrive::Spreadsheet] an spreadsheet agent
      #   (used internally only)
      def initialize(session: nil, spreadsheet_key: nil, agent: nil)
        @agent = agent
        @session = session
        @spreadsheet_key = spreadsheet_key
      end

      # @return [Boolean] Whether the worksheet has unsaved changes
      def dirty?
        ws.dirty?
      end

      # @return [String] the spreadsheet version
      # @see AspireBudget::Worksheets::BackendData#version
      def spreadsheet_version
        @backend_data ||= BackendData.new(agent: agent)
        @backend_data.version
      end

      private

      def ws
        worksheets[self.class::WS_TITLE]
      end

      def worksheets
        @worksheets ||=
          agent.worksheets.reduce({}) { |h, sheet| h.merge(sheet.title => sheet) }
      end

      def agent
        @agent ||= AspireBudget.configuration.agent(@session, @spreadsheet_key)
      end
    end
  end
end
