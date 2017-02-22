# frozen_string_literal: true
module Europeana
  module Logging
    module LogSessionId
      extend ActiveSupport::Concern

      ##
      # Overrides `#logger` in controller to first set session via
      # `Europeana::Logging::SessionLogging#session=`
      def logger(*args)
        super.session = session unless @_request.nil?
        super(*args)
      end
    end
  end
end
