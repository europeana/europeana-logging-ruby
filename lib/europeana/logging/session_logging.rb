module Europeana
  module Logging
    module SessionLogging
      attr_accessor :session

      %w(unknown fatal error warn info debug).each do |level|
        define_method level do |message|
          hmessage = message.is_a?(Hash) ? message.dup : { message: message.dup }
          hmessage[:session_id] = session.id
          super(hmessage)
        end
      end
    end
  end
end
