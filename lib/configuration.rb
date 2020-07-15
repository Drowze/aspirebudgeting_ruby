# frozen_string_literal: true

require 'money'

module AspireBudget
  def self.configure
    yield(configuration)
  end

  def self.configuration
    @configuration ||= Configuration.new
  end

  def self.reset!
    @configuration = Configuration.new
  end

  class Configuration
    attr_writer :session, :spreadsheet_key

    def session
      @session || raise('Please set session')
    end

    def spreadsheet_key
      @spreadsheet_key || raise('Please set spreadsheet key')
    end

    def currency=(value)
      @currency = Money::Currency.new(value)
    end

    def currency
      @currency ||= Money::Currency.new('EUR')
    end

    def agent(session: nil, spreadsheet_key: nil)
      if session.nil? || spreadsheet_key.nil?
        @agent ||= self.session.spreadsheet_by_key(self.spreadsheet_key)
      else
        @agents ||= Hash.new do |h, k|
          h[k] = session.spreadsheet_by_key(k.last)
        end


        @agents[[session, spreadsheet_key]]
      end
    end
  end
end
