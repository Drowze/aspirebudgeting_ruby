# frozen_string_literal: true
require 'pry'
require 'bundler/setup'
require 'google_drive'
require 'aspire_budget'

class ManageFixtures
  include Rake::DSL

  FIXTURES_RELATIVE_PATH = '../spec/fixtures/'

  SPREADSHEET_KEYS = {
    'v3-1-0' => '1RHgsiisoZRsMVUp286UV9SipGIDYKxgAuzkkGzWeV2A',
    'v3-2-0' => '1qcTJ885txKWr4gc1pIR0iWAc1nHzYMzpDIxsQvA4Go0'
  }

  def initialize
    active_worksheet_klasses = [
      AspireBudget::Worksheets::Transactions,
      AspireBudget::Worksheets::CategoryTransfers,
      AspireBudget::Worksheets::BackendData
    ]

    namespace :fixtures do
      task :update do
        SPREADSHEET_KEYS.each do |key|
          build_worksheets!(version, key, *active_worksheet_klasses)
          update_fixtures(version)
        end
      end

      task :validate do
        SPREADSHEET_KEYS.each_pair do |version, spreadsheet_key|
          build_worksheets!(version, spreadsheet_key, *active_worksheet_klasses)
          validate_fixtures(version)
        end
      end
    end
  end

  private

  def build_worksheets!(version, key, *klasses)
    @worksheets ||= {}
    @worksheets[version] ||= klasses.reduce({}) do |h, klass|
      h.merge(klass::WS_TITLE => klass.new(session: session, spreadsheet_key: key))
    end
  end

  def session
    @session ||= GoogleDrive::Session.from_service_account_key(nil)
  end

  def file_path(version, title)
    filename = title.downcase.gsub(' ', '_') + '.json'
    "#{__dir__}/#{FIXTURES_RELATIVE_PATH}#{version}/#{filename}"
  end

  def fixture_for(worksheet)
    worksheet.send(:ws).rows.then(&JSON.method(:pretty_generate))
  end

  def update_fixtures(version)
    @worksheets[version].each_pair do |title, worksheet|
      File.write(file_path(version, title), fixture_for(worksheet))
    end
  end

  def validate_fixtures(version)
    @worksheets[version].each_pair do |title, worksheet|
      existing_fixture = File.read(file_path(version, title))
      raise 'Fixture not up to date' if existing_fixture != fixture_for(worksheet)
    end
  end
end

# register the tasks
ManageFixtures.new
