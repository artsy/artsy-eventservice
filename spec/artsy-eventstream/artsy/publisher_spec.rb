# frozen_string_literal: true
require 'spec_helper'
require 'json'

describe Artsy::EventService::Publisher do
  let(:event) { double('event', topic: 'foo') }

  before do
    Artsy::EventService.configure do |config|
      config.app_name = 'artsy'
      config.event_stream_enabled = true
      config.tls = true
    end
    allow(event).to receive_messages(
      verb: 'testing',
      json: JSON.generate(hello: true)
    )
  end

  describe '.publish' do
    it 'fails when topic is empty' do
      expect { Artsy::EventService::Publisher.publish(topic: nil, event: event) }.to raise_error 'Event missing topic or verb.'
    end
    it 'fails when event.verb is empty' do
      allow(event).to receive(:verb).and_return('')
      expect { Artsy::EventService::Publisher.publish(topic: 'test', event: event) }.to raise_error 'Event missing topic or verb.'
    end
    it 'fails when event.verb is nil' do
      allow(event).to receive(:verb).and_return(nil)
      expect { Artsy::EventService::Publisher.publish(topic: 'test', event: event) }.to raise_error 'Event missing topic or verb.'
    end
    it 'uses verb as routing key when calling publish on the exchange without passing routing_key' do
      conn = double
      channel = double
      exchange = double
      allow(Artsy::EventService::RabbitMQConnection).to receive(:get_connection).with(no_args).and_return(conn)
      allow(conn).to receive(:create_channel).and_return(channel)
      allow(channel).to receive(:open?).and_return(true)
      allow(channel).to receive(:topic).with('test', durable: true).and_return(exchange)
      allow(channel).to receive(:confirm_select)
      allow(channel).to receive(:wait_for_confirms).and_return(true)
      allow(channel).to receive(:close)

      expect(exchange).to receive(:publish).with(
        JSON.generate(hello: true),
        routing_key: 'testing',
        persistent: true,
        content_type: 'application/json',
        app_id: 'artsy'
      )
      Artsy::EventService::Publisher.publish(topic: 'test', event: event)
    end
    it 'uses verb as routing key when calling publish on the exchange without passing routing_key' do
      conn = double
      channel = double
      exchange = double
      allow(Artsy::EventService::RabbitMQConnection).to receive(:get_connection).with(no_args).and_return(conn)
      allow(conn).to receive(:create_channel).and_return(channel)
      allow(channel).to receive(:open?).and_return(true)
      allow(channel).to receive(:topic).with('test', durable: true).and_return(exchange)
      allow(channel).to receive(:confirm_select)
      allow(channel).to receive(:wait_for_confirms).and_return(true)
      allow(channel).to receive(:close)

      expect(exchange).to receive(:publish).with(
        JSON.generate(hello: true),
        routing_key: 'good.route',
        persistent: true,
        content_type: 'application/json',
        app_id: 'artsy'
      )
      Artsy::EventService::Publisher.publish(topic: 'test', event: event, routing_key: 'good.route')
    end
    it 'raises an error if event publishing is unconfirmed' do
      conn = double
      channel = double
      exchange = double
      allow(Artsy::EventService::RabbitMQConnection).to receive(:get_connection).with(no_args).and_return(conn)
      allow(conn).to receive(:create_channel).and_return(channel)
      allow(channel).to receive(:open?).and_return(true)
      allow(channel).to receive(:topic).with('test', durable: true).and_return(exchange)
      allow(channel).to receive(:confirm_select)
      allow(channel).to receive(:wait_for_confirms).and_return(false)
      allow(channel).to receive(:close)

      expect(exchange).to receive(:publish).with(
        JSON.generate(hello: true),
        routing_key: 'good.route',
        persistent: true,
        content_type: 'application/json',
        app_id: 'artsy'
      )
      expect do
        Artsy::EventService::Publisher.publish(topic: 'test', event: event, routing_key: 'good.route')
      end.to raise_error 'Publishing event failed'
    end
  end
end
