# frozen_string_literal: true
require 'bunny'

module Artsy
  module EventService
    module RabbitMQConnection
      # get a new RabbitMQ Client
      def create_conn
        Bunny.new(rabbitmq_url, **bunny_params)
      end

      # Connect, do something and close the connection
      def connect_to_rabbit
        conn = create_conn
        conn.start
        yield(conn)
        conn.stop
      end

      def rabbitmq_url
        config.rabbitmq_url
      end

      def bunny_params
        config.tls ? tls_params : no_tls_params
      end

      def tls_params
        {
          tls: config.tls,
          tls_cert: config.tls_cert,
          tls_key: config.tls_key,
          tls_ca_certificates: [config.tls_ca_certificate],
          verify_peer: config.verify_peer
        }
      end

      def no_tls_params
        raise 'not implemented- TLS only'
      end

      def config
        Artsy::EventService.config
      end
    end
  end
end
