# frozen_string_literal: true
require 'spec_helper'

describe Artsy::EventService do
  let(:event) { double('event', topic: 'foo', verb: 'bar') }

  context 'configuration' do
    describe '.config' do
      it 'accesses the module configuration' do
        expect(Artsy::EventService.config.app_name).to eq 'artsy'
      end
    end
    describe '.configure' do
      before { stub_const 'Artsy::EventService::CONFIG', Artsy::EventService::CONFIG.dup }
      it 'allows access to the module, including mutable configuration' do
        default = Artsy::EventService.config.event_stream_enabled
        expected = !default
        Artsy::EventService.configure { |es| es.config.event_stream_enabled = expected}
        expect(Artsy::EventService.config.event_stream_enabled).to be expected
      end
      it 'freezes the config' do
        Artsy::EventService.configure { |es| es.config.app_name = 'foo' }
        expect { Artsy::EventService.config.app_name = 'bar' }.to raise_error RuntimeError
      end
    end

  end

  context 'event stream disabled' do
    before do
      stub_const('Artsy::EventService::CONFIG', double(event_stream_enabled: false))
    end
    describe '.post_event' do
      it 'does not connect to rabbit' do
        expect(Artsy::EventService::Publisher).not_to receive(:publish)
        Artsy::EventService.post_event(topic: 'test', event: event)
      end
    end
    describe '.consume' do
      it 'does not connect to rabbit' do
        expect(Artsy::EventService::Consumer).not_to receive(:consume)
        Artsy::EventService.consume(topic: 'test', event: event)
      end
    end
  end

  context 'event stream enabled' do
    before do
      stub_const('Artsy::EventService::CONFIG', double(event_stream_enabled: true))
    end
    describe '.post_event' do
      it 'does connect to rabbit' do
        expect(Artsy::EventService::Publisher).to receive(:publish)

        Artsy::EventService.post_event(topic: 'test', event: event)
      end
    end
    describe '.consume' do
      it 'does connect to rabbit' do
        expect(Artsy::EventService::Consumer).to receive(:consume)
        Artsy::EventService.consume(topic: 'test', event: event)
      end
    end
  end
end
