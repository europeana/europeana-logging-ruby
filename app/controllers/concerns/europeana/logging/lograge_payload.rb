# frozen_string_literal: true
module Europeana
  module Logging
    module LogragePayload
      extend ActiveSupport::Concern

      def append_info_to_payload(payload)
        super
        payload[:session_id] = session.id
      end
    end
  end
end
