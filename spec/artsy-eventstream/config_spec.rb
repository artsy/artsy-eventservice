# frozen_string_literal: true
require 'spec_helper'
describe Artsy::EventService::Config do
  describe '.configure' do
    %w(app_name event_stream_enabled rabbitmq_url tls tls_ca_certificate tls_cert tls_key verify_peer).each do |option|
      it "allows setting and getting #{option}" do
        Artsy::EventService.configure { |config| config.send("#{option}=", false) }
        expect(Artsy::EventService.config.send(option.to_sym)).to be false
      end
    end
  end
end
