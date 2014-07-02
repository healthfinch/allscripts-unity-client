module AllscriptsUnityClient
  module NewRelicSupport
    def self.enable_method_tracer(instance)
      class << instance
        if !respond_to?(:trace_execution_scoped) && !respond_to?(:add_method_tracer)
          extend ::NewRelic::Agent::MethodTracer
        end
      end
    end

    def self.trace_execution_scoped_if_available(klass, scope)
      if klass.respond_to?(:trace_execution_scoped)
        klass.trace_execution_scoped(scope, &Proc.new)
      else
        yield if block_given?
      end
    end
  end
end