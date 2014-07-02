require 'spec_helper'

describe AllscriptsUnityClient::NewRelicSupport do
  subject { described_class }
  let(:scope) { ['scope'] }
  let(:block) { lambda {} }

  before :all do
    # Mock a test class for NewRelic mixin tests.
    class NewRelicSupportTest
    end
  end

  describe '.enable_method_tracer' do
    context 'when given an object that does not have the NewRelic::Agent::MethodTracer module mixed in' do
      it 'mixes in the NewRelic::Agent::MethodTracer module' do
        allow(NewRelicSupportTest).to receive(:extend)
        subject.enable_method_tracer(NewRelicSupportTest.new)
        expect(NewRelicSupportTest).to have_received(:extend).with(::NewRelic::Agent::MethodTracer)
      end
    end

    context 'when given an object that does have the NewRelic::Agent::MethodTracer module mixed in' do
      it 'does not mix in the NewRelic::Agent::MethodTracer module' do
        allow(NewRelicSupportTest).to receive(:extend)
        allow(NewRelicSupportTest).to receive(:trace_execution_scoped)
        allow(NewRelicSupportTest).to receive(:add_method_tracer)
        subject.enable_method_tracer(NewRelicSupportTest.new)
        expect(NewRelicSupportTest).not_to have_received(:extend).with(::NewRelic::Agent::MethodTracer)
      end
    end
  end

  describe '.trace_execution_scoped_if_available' do
    context 'when a class does not have trace_execution_scoped and is given block' do
      it 'will yield to the block' do
        expect { |b| subject.trace_execution_scoped_if_available(NewRelicSupportTest, scope, &b) }.to yield_control
      end
    end

    context 'when a class has trace_execution_scoped and is given a block' do
      it 'will pass the block to trace_execution_scoped' do
        allow(NewRelicSupportTest).to receive(:trace_execution_scoped)
        subject.trace_execution_scoped_if_available(NewRelicSupportTest, scope, &block)
        expect(NewRelicSupportTest).to have_received(:trace_execution_scoped).with(scope)
      end
    end
  end
end