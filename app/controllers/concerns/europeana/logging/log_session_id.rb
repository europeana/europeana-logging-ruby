# frozen_string_literal: true
module Europeana
  module Logging
    module LogSessionId
      extend ActiveSupport::Concern

      ##
      # Overrides `#logger` in controller to first set session via
      # `Europeana::Logging::SessionLogging#session=`
      def logger(*args)
        super.session_id = session_id_from_session unless @_request.nil?
        super(*args)
      end

      ##
      # Lograge payload
      def append_info_to_payload(payload)
        super
        payload[:session_id] = session_id_from_session unless session_id_from_session.blank?

        # Cloudflare client IP and country data
        payload[:cf_connecting_ip] = request.headers['CF-Connecting-IP']
        payload[:cf_ipcountry] = request.headers['CF-IPCountry']
      end

      def session_id_from_session
        session.respond_to?(:id) ? session.id : nil
      end
    end
  end
end
