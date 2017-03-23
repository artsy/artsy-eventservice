# frozen_string_literal: true
require 'spec_helper'

describe Events::BaseEvent do
  let(:model) { double('model') }
  let(:user) { double('user') }
  let(:event) { Events::BaseEvent.new(user: user, action: 'test', model: model) }
  before do
    allow(model).to receive_messages(
      id: 'model-1',
      to_s: 'Model 1'
    )
    allow(user).to receive_messages(
      id: 'user-1',
      to_s: 'User 1'
    )
  end
  describe '#json' do
    it 'returns proper json' do
      expect(JSON.parse(event.json)).to match(
        'verb' => 'test',
        'subject' => {
          'id' => 'user-1',
          'display' => 'User 1'
        },
        'object' => {
          'id' => 'model-1',
          'root_type' => 'RSpec::Mocks::Double',
          'display' => 'Model 1'
        },
        'properties' => nil
      )
    end
  end
end
