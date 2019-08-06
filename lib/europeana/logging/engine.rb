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
        if app.config.lograge.custom_options.nil?
          app.config.lograge.custom_options = lambda do |event|
            {}.tap do |custom|
              if event.payload.key?(:redis_runtime)
                custom[:redis] = event.payload[:redis_runtime].to_f.round(2)
              end
              %i(session_id cf_connecting_ip cf_ipcountry).each do |key|
                if event.payload.key?(key)
                  custom[key] = event.payload[key]
                end
              end
            end
          end
        end

        app.config.lograge.formatter = Lograge::Formatters::Logstash.new
      end

      # Configure Logstash
      initializer 'europeana_logging.configure_logstash' do |_app|
        LogStashLogger.configure do |config|
          config.customize_event do |event|
            event['level'] = event.remove('severity')
            event['thread'] = Thread.current.object_id.to_s
          end
        end
      end

      # Init app loggers
      initializer 'europeana_logging.set_app_loggers' do |app|
        app.config.logger = LogStashLogger.new(type: :stdout)

        Rails.logger = LogStashLogger.new(type: :stdout)

        ApplicationController.superclass.logger = LogStashLogger.new(type: :stdout)
        ApplicationController.superclass.logger.extend(Europeana::Logging::SessionLogging)
      end

      # Controller concern for session ID logging
      initializer 'europeana_logging.application_controller_log_session_id' do |_app|
        ApplicationController.send :include, Europeana::Logging::LogSessionId
      end
    end
  end
end
