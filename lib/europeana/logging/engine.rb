# frozen_string_literal: true
require 'lograge'
require 'logstash-logger'

module Europeana
  module Logging
    class Engine < ::Rails::Engine
      # Enable lograge
      initializer 'europeana_logging.enable_lograge' do |app|
        app.config.lograge.enabled = true
      end

      # Configure lograge
      initializer 'europeana_logging.configure_lograge' do |app|
        ApplicationController.send :include, Europeana::Logging::LogragePayload

        app.config.lograge.custom_options = lambda do |event|
          {}.tap do |custom|
            if event.payload.key?(:redis_runtime)
              custom[:redis] = event.payload[:redis_runtime].to_f.round(2)
            end
            if event.payload.key?(:session_id)
              custom[:session_id] = event.payload[:session_id]
            end
          end
        end

        app.config.lograge.formatter = Lograge::Formatters::Logstash.new
      end

      # Configure Logstash
      initializer 'europeana_logging.configure_logstash' do |app|
        stdout_logger = LogStashLogger.new(type: :stdout)
        app.config.logger = Rails.logger = ActionController::Base.logger = stdout_logger
        LogStashLogger.configure do |config|
          config.customize_event do |event|
            event['level'] = event.remove('severity')
            event['thread'] = Thread.current.object_id.to_s
          end
        end
      end
    end
  end
end
