# frozen_string_literal: true

module AspireBudget
  def self.configure
    yield(configuration)
  end

  def self.configuration
    @configuration ||= Configuration.new
  end

  class Configuration
    attr_writer :session
    attr_writer :spreadsheet_key

    def session
      @session || raise('Please set session')
    end

    def spreadsheet_key
      @spreadsheet_key || raise('Please set spreadsheet key')
    end

    def agent(session: nil, spreadsheet_key: nil)
      if session.nil? || spreadsheet_key.nil?
        @agent ||= self.session.spreadsheet_by_key(self.spreadsheet_key)
      else
        @agents ||= Hash.new do |h, k|
          h[k] = session.spreadsheet_by_key(spreadsheet_key)
        end

        @agents[[session, spreadsheet_key]]
      end
    end
  end
end
