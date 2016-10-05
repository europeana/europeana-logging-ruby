# frozen_string_literal: true
require 'lograge'
require 'logstash-logger'

module Europeana
  module Logging
    class Engine < ::Rails::Engine
      # Set log level
      initializer 'europeana_logging.set_log_level' do |app|
        app.config.log_level = (Rails.env == 'production' ? :info : :debug)
      end

      # Enable lograge
      initializer 'europeana_lobbing.enable_lograge' do |app|
        app.config.lograge.enabled = true
      end

      if Rails.env == 'production'
        # Configure lograge
        initializer 'europeana_lobbing.configure_lograge' do |app|
          app.config.lograge.custom_options = lambda do |event|
            if event.payload.key?(:redis_runtime)
              { redis: event.payload[:redis_runtime].to_f.round(2) }
            else
              {}
            end
          end
          app.config.lograge.formatter = Lograge::Formatters::Logstash.new
        end

        # Configure Logstash
        initializer 'europeana_logging.configure_logstash' do |app|
          app.config.logger = LogStashLogger.new(type: :stdout)
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
end
