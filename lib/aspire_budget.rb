# frozen_string_literal: true

require 'configuration'

require 'worksheets/backend_data'
require 'worksheets/transactions'
require 'worksheets/category_transfers'

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
