require 'json'

module Events
  class BaseEvent
    attr_reader :verb, :subject, :object, :properties
    def initialize(user: nil, action:, model:)
      @subject = user
      @verb = action
      @object = model
      @properties = nil
    end

    def subject
      {
        id: @subject.id.to_s || '',
        display: @subject.to_s
      } if @subject
    end

    def object
      {
        id: @object.id.to_s,
        root_type: @object.class.to_s,
        display: @object.to_s
      } if @object
    end

    def json
      JSON.generate({
        verb: @verb,
        subject: subject,
        object: object,
        properties: properties
      })
    end
  end
end
