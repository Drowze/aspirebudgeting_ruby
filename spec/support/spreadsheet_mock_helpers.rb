# frozen_string_literal: true

require 'google_drive'
require 'aspire_budget/configuration'

module SpreadsheetMockHelpers
  def worksheet_version(version)
    described_class.new(**worksheet_params_for(version))
  end

  def worksheet_params_for(version)
    {
      session: GoogleDrive::Session.new(Object),
      spreadsheet_key: version
    }
  end

  def worksheet_config_for(version)
    AspireBudget::Configuration.new.tap do |config|
      worksheet_params_for(version).each_pair do |attr, value|
        config.send("#{attr}=", value)
      end
    end
  end
end
