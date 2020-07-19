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
    attr_accessor :session, :spreadsheet_key

    def currency=(value)
      @currency = Money::Currency.new(value)
    end

    def currency
      @currency ||= Money::Currency.new('EUR')
    end

    def agent(session = nil, spreadsheet_key = nil)
      @agents ||= Hash.new do |h, k|
        h[k] = k.first.spreadsheet_by_key(k.last)
      end
      @agents[
        [session || self.session, spreadsheet_key || self.spreadsheet_key]
      ]
    end
  end
end
