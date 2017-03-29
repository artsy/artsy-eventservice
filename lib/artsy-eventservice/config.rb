# frozen_string_literal: true
require 'ostruct'
module Artsy
  module EventService
    def self.initial_config
      {
        app_name: defined?(Rails) ? Rails.application.class.to_s.split('::').first : 'artsy',
        event_stream_enabled:         ENV['EVENT_STREAM_ENABLED'] == 'true',
        rabbitmq_url:                 ENV['RABBITMQ_URL'] || nil,
        tls:                          !(ENV['RABBITMQ_NO_TLS'] == 'true'),
        tls_ca_certificate:           ENV['RABBITMQ_CA_CERT']     ? Base64.decode64(ENV['RABBITMQ_CA_CERT'])     : nil,
        tls_cert:                     ENV['RABBITMQ_CLIENT_CERT'] ? Base64.decode64(ENV['RABBITMQ_CLIENT_CERT']) : nil,
        tls_key:                      ENV['RABBITMQ_CLIENT_KEY']  ? Base64.decode64(ENV['RABBITMQ_CLIENT_KEY'])  : nil,
        verify_peer:                  !(ENV['RABBITMQ_NO_VERIFY_PEER'] == 'true')
      }
    end
  end
end
