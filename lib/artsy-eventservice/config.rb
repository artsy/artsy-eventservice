# frozen_string_literal: true

module Artsy
  module EventService
    module Config
      extend self

      attr_accessor :app_name
      attr_accessor :event_stream_enabled
      attr_accessor :rabbitmq_url
      attr_accessor :tls
      attr_accessor :tls_ca_certificate
      attr_accessor :tls_cert
      attr_accessor :tls_key
      attr_accessor :verify_peer

      def reset
        self.app_name = nil
        self.event_stream_enabled = false
        self.rabbitmq_url = nil
        self.tls = nil
        self.tls_ca_certificate = nil
        self.tls_cert = nil
        self.tls_key = nil
        self.verify_peer = nil
      end

      reset
    end

    class << self
      def configure
        yield(Config) if block_given?
        Config
      end

      def config
        Config
      end
    end
  end
end
