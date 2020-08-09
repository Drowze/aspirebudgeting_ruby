# frozen_string_literal: true

require_relative './auth'

module GoogleApiMock
  class DriveService
    include Auth

    def initialize(spreadsheet_repo)
      @spreadsheet_repo = spreadsheet_repo
    end

    def get_file(id, opts = {})
      @spreadsheet_repo.by_version(id, opts)
    end
  end
end
