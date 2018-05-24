# frozen_string_literal: true
require 'bunny'

module Artsy
  module EventService
    class RabbitMQConnection
      @connection = nil
      @mutex = Mutex.new

      # Build a new connection to RabbitMQ
      def self.build_connection
        conn = Bunny.new(self.rabbitmq_url, **self.bunny_params)
        conn.start
        conn
      end

      # Synchronized access to the connection
      def self.get_connection
        @mutex.synchronize do
          @connection ||= self.build_connection
          @connection = self.build_connection if @connection.closed?
          @connection
        end
      end

      # Get a channel from the connection - synchronized access to create_channel is provided by Bunny
      def self.get_channel
        channel = self.get_connection.create_channel
        yield channel if block_given?
      ensure
        channel.close if channel && channel.open?
      end

      def self.rabbitmq_url
        self.config.rabbitmq_url
      end

      def self.bunny_params
        self.config.tls ? self.tls_params : self.no_tls_params
      end

      def self.tls_params
        {
          tls: self.config.tls,
          tls_cert: self.config.tls_cert,
          tls_key: self.config.tls_key,
          tls_ca_certificates: [self.config.tls_ca_certificate],
          verify_peer: self.config.verify_peer
        }
      end

      def self.no_tls_params
        {}
      end

      def self.config
        Artsy::EventService.config
      end
    end
  end
end
