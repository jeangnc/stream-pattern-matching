# frozen_string_literal: true

require 'json'
require_relative 'condition'
require_relative 'event'
require_relative 'proto/complex_event_processor_services_pb'

module ComplexEventProcessor
  class Client
    SERVICE_URL = ENV.fetch('complex_event_processor_URL', 'localhost:8080')

    def initialize(url: SERVICE_URL, security: :this_channel_is_insecure)
      @stub = ComplexEventProcessor::Proto::EventStream::Stub.new(url, security)
    end

    def register_condition(condition)
      request = ComplexEventProcessor::Proto::RegisterRequest.new(
        condition: ComplexEventProcessor::Proto::Condition.new(
          id: condition.id,
          tenant_id: condition.tenant_id,
          event_type: condition.event_type,
          predicates: condition.predicates.map do |predicate|
            ComplexEventProcessor::Proto::Predicate.new(
              name: predicate.name,
              operator: predicate.operator,
              value: Google::Protobuf::Value.new(string_value: predicate.value),
            )
          end,
          desired_result: true
        )
      )

      @stub.register_condition(request)
    end

    def filter(event)
      request = ComplexEventProcessor::Proto::FilterRequest.new(
        event: ComplexEventProcessor::Proto::Event.new(
          id: event.id,
          tenant_id: event.tenant_id,
          kind: event.kind,
          payload:  Google::Protobuf::Struct.new(
            fields: event.payload.each_with_object({}) do |(k, v), memo|
              memo[k] = Google::Protobuf::Value.new(string_value: v)
            end
          ),
        )
      )

      @stub.filter(request)
    end
  end
end
