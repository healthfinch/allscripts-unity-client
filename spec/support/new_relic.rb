RSpec.configure do |config|
  config.before(:suite) do
    # Mock the NewRelic::Agent::MethodTracer module
    module NewRelic
      module Agent
        module MethodTracer
          def trace_execution_scoped
          end

          def add_method_tracer
          end
        end
      end
    end
  end
end