# frozen_string_literal: true

module Tango
  module Api
    module Resources
      # Resource for platform/system status checks.
      class Status < Base
        # GET /status
        def get
          get_json("status")
        end
      end
    end
  end
end
