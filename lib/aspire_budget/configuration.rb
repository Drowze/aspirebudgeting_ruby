# frozen_string_literal: true

module AspireBudget
  # Configures default values
  def self.configure
    yield(configuration) if block_given?
  end

  # @return [AspireBudget::Configuration] the current configured defaults
  def self.configuration
    Thread.current[:aspire_budget_configuration] ||= Configuration.new
  end

  # Overwrite the current configured defaults
  # @param [AspireBudget::Configuration]
  def self.configuration=(other)
    Thread.current[:aspire_budget_configuration] = other
  end

  # Resets the set configuration. Useful on e.g. testing
  def self.reset!
    Thread.current[:aspire_budget_configuration] = nil
  end

  class Configuration
    # Authenticated GoogleDrive session
    # @return [GoogleDrive::Session]
    attr_accessor :session

    # Google spreadsheet key (as it is in the url)
    # @return [String]
    attr_accessor :spreadsheet_key

    # Build an agent using given +session+ and +spreadsheet_key+ (falling back
    # to the configured ones).
    # @return [GoogleDrive::Spreadsheet] an spreadsheet agent
    # @param session [GoogleDrive::Session] will fallback to configured one if
    #   not defined
    # @param spreadsheet_key [String] will fallback to configured one if not
    #   defined
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
