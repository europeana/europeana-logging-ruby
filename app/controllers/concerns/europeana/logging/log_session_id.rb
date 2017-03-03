# frozen_string_literal: true
module Europeana
  module Logging
    module LogSessionId
      extend ActiveSupport::Concern

      ##
      # Overrides `#logger` in controller to first set session via
      # `Europeana::Logging::SessionLogging#session=`
      def logger(*args)
        super.session_id = session.id unless @_request.nil?
        super(*args)
      end

      ##
      # Lograge payload
      def append_info_to_payload(payload)
        super
        payload[:session_id] = session.id
      end
    end
  end
end
