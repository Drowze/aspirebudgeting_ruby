# frozen_string_literal: true

require 'pry'
require 'bundler/setup'
require 'google_drive'
require 'aspire_budget'

class ManageFixtures
  include Rake::DSL

  FIXTURES_RELATIVE_PATH = '../spec/support/fixtures/'

  SPREADSHEET_KEYS = {
    'v3-1-0' => '1RHgsiisoZRsMVUp286UV9SipGIDYKxgAuzkkGzWeV2A',
    'v3-2-0' => '1qcTJ885txKWr4gc1pIR0iWAc1nHzYMzpDIxsQvA4Go0'
  }.freeze

  ACTIVE_WORKSHEET_KLASSES = [
    AspireBudget::Worksheets::Transactions,
    AspireBudget::Worksheets::CategoryTransfers,
    AspireBudget::Worksheets::BackendData
  ].freeze

  def initialize
    namespace :fixtures do
      task :update do
        SPREADSHEET_KEYS.each_key(&method(:update_fixtures))
      end

      task :validate do
        SPREADSHEET_KEYS.each_key(&method(:validate_fixtures))
      end
    end
  end

  private

  def worksheets
    @worksheets ||= SPREADSHEET_KEYS.reduce({}) do |h, (version, key)|
      worksheets = ACTIVE_WORKSHEET_KLASSES.reduce({}) do |h2, klass|
        h2.merge(klass::WS_TITLE => klass.new(session: session, spreadsheet_key: key))
      end

      h.merge(version => worksheets)
    end
  end

  def session
    @session ||= GoogleDrive::Session.from_service_account_key(nil)
  end

  def file_path(version, title)
    file_basename = title.downcase.tr(' ', '_')
    "#{__dir__}/#{FIXTURES_RELATIVE_PATH}#{version}/#{file_basename}.json"
  end

  def fixture_for(worksheet)
    worksheet.send(:ws).rows.then(&JSON.method(:pretty_generate))
  end

  def update_fixtures(version)
    worksheets[version].each_pair do |title, worksheet|
      File.write(file_path(version, title), fixture_for(worksheet))
    end
  end

  def validate_fixtures(version)
    worksheets[version].each_pair do |title, worksheet|
      existing_fixture = File.read(file_path(version, title))
      raise 'Fixture not up to date' if existing_fixture != fixture_for(worksheet)
    end
  end
end

# register the tasks
ManageFixtures.new
