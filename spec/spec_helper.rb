# frozen_string_literal: true
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))

require 'rubygems'
require 'rspec'
require 'artsy-eventservice'
require 'pry'

RSpec.configure do |c|
  # c.before(:each) do
  #   stub_const('Artsy::EventService::CONFIG', double(
  #     app_name: 'artsy',
  #     event_stream_enabled: 'true',
  #     rabbitmq_url: 'amqp://foo',
  #     tls: 'true',
  #     tls_ca_certificate: 'tlsca',
  #     tls_cert: 'cert',
  #     tls_key: 'key',
  #     verify_peer: 'true'
  #   ))
  # end
end
