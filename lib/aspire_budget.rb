# frozen_string_literal: true

require 'aspire_budget/core_extensions'

require 'aspire_budget/version'
require 'aspire_budget/configuration'

require 'aspire_budget/worksheets/backend_data'
require 'aspire_budget/worksheets/transactions'
require 'aspire_budget/worksheets/category_transfers'

require 'aspire_budget/models/transaction'
require 'aspire_budget/models/category_transfer'

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
