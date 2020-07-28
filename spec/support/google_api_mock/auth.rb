# frozen_string_literal: true

module GoogleApiMock
  module Auth
    def authorization=(other); end

    def client_options
      @client_options ||=
        Struct.new(:open_timeout_sec, :read_timeout_sec, :send_timeout_sec)
              .new(nil, nil, nil)
    end
  end
end
