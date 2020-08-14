# frozen_string_literal: true

require 'core_extensions'

require 'configuration'

require 'worksheets/backend_data'
require 'worksheets/transactions'
require 'worksheets/category_transfers'
require 'worksheets/dashboard'

require 'models/transaction'
require 'models/category_transfer'

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
