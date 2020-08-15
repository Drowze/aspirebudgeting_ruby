# frozen_string_literal: true

require_relative 'aspire_budget/core_extensions'

require_relative 'aspire_budget/version'
require_relative 'aspire_budget/configuration'

require_relative 'aspire_budget/worksheets/backend_data'
require_relative 'aspire_budget/worksheets/transactions'
require_relative 'aspire_budget/worksheets/category_transfers'

require_relative 'aspire_budget/models/transaction'
require_relative 'aspire_budget/models/category_transfer'

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
end
