# frozen_string_literal: true
require 'spec_helper'

describe Artsy::EventService do
  let(:event) { double('event', topic: 'foo', verb: 'bar') }

  context 'configuration' do
    describe 'config' do
      it 'accesses the module configuration' do
        expect(Artsy::EventService.config.app_name).to eq 'artsy'
      end
      it 'is frozen' do
        expect { Artsy::EventService.config.app_name = 'foo' }.to raise_error RuntimeError
      end
    end
  end

  context 'event stream disabled' do
    before do
      stub_const('Artsy::EventService::CONFIG', double(event_stream_enabled: false))
    end
    describe '.post_event' do
      it 'does not post event' do
        expect(Artsy::EventService::Publisher).not_to receive(:publish)
        Artsy::EventService.post_event(topic: 'test', event: event)
      end
    end
  end

  context 'event stream enabled' do
    before do
      stub_const('Artsy::EventService::CONFIG', double(event_stream_enabled: true))
    end
    describe '.post_event' do
      it 'does post event' do
        expect(Artsy::EventService::Publisher).to receive(:publish)

        Artsy::EventService.post_event(topic: 'test', event: event)
      end
    end
  end
end
