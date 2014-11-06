module AllscriptsUnityClient

  # A mixin to provide support for New Relic instrumentation.
  module NewRelicSupport

    # Mixin NewRelic::Agent::MethodTracer for a given object.
    #
    # instance:: The object to use as the target for the mixin.
    def self.enable_method_tracer(instance)
      class << instance
        if !respond_to?(:trace_execution_scoped) && !respond_to?(:add_method_tracer)
          extend ::NewRelic::Agent::MethodTracer
        end
      end
    end

    # If a given class supports New Relic trace_execution_scoped, then
    # run the given block using that method.
    #
    # klass:: The target class.
    # scope:: A New Relic scope string.
    def self.trace_execution_scoped_if_available(klass, scope)
      if klass.respond_to?(:trace_execution_scoped)
        klass.trace_execution_scoped(scope, &Proc.new)
      else
        yield if block_given?
      end
    end
  end
end