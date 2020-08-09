# frozen_string_literal: true

module GoogleApiMock
  class Fixtures
    class << self
      FIXTURES_PATH = "#{__dir__}/../../fixtures/"

      def load_data(version)
        @load_data ||= {}
        @load_data[version] ||= fixtures_available_for(version).map do |fixture_name|
          {
            sheet_title: sheet_title(fixture_name),
            fixture: load_fixture(version, "#{fixture_name}.json"),
            properties: load_fixture(version, "#{fixture_name}_properties.json")
          }
        end
      end

      private

      def sheet_title(fixture_name)
        return 'BackendData' if fixture_name == 'backenddata'

        fixture_name.split(/ |_|-/).map(&:capitalize).join(' ')
      end

      def load_fixture(version, filename)
        JSON.parse File.read("#{FIXTURES_PATH}/#{version}/#{filename}")
      rescue Errno::ENOENT # rubocop:disable Lint/SuppressedException
      end

      def fixtures_available_for(version)
        Dir.glob("#{FIXTURES_PATH}/#{version}/*.json")
           .reject { |f| f.match?(/_properties\.json/) }
           .map { |f| File.basename(f, '.json') }
      end
    end
  end
end
