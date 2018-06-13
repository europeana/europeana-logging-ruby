module Europeana
  module Logging
    module SessionLogging
      attr_accessor :session_id

      %w(unknown fatal error warn info debug).each do |level|
        define_method level.to_sym do |message=nil|
          message = yield if message.nil? && block_given?
          hmessage = message.is_a?(Hash) ? message.dup : { message: message }
          hmessage[:session_id] = session_id unless session_id.blank?
          super(hmessage)
        end
      end
    end
  end
end
