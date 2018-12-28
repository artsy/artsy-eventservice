# frozen_string_literal: true
require 'json'

module Events
  class BaseEvent
    attr_reader :verb, :subject, :object, :properties

    def initialize(user: nil, action:, model:)
      @subject = user
      @verb = action
      @object = model
    end

    def subject
      if @subject
        {
          id: @subject.id.to_s || '',
          display: @subject.to_s
        }
      end
    end

    def object
      if @object
        {
          id: @object.id.to_s,
          root_type: @object.class.to_s,
          display: @object.to_s
        }
      end
    end

    def to_json
      JSON.generate(verb: @verb,
                    subject: subject,
                    object: object,
                    properties: properties)
    end

    def json
      # Deprecated, switch to to_json
      to_json
    end

    def routing_key
      "#{@object.class.to_s.downcase.gsub('::', '-')}.#{@verb}"
    end
  end
end
