require 'spec_helper'

describe BindingDumper::Memories do
  subject(:memory) do
    Object.new.tap { |o| o.extend(BindingDumper::Memories) }
  end

  context '.memories' do
    context 'when not initialized' do
      it 'returns blank hash by default' do
        expect(memory.memories).to eq({})
      end
    end

    context 'when initialized' do
      before { memory.remember!(String, 123) }

      it 'returns object_id => object mapping' do
        expect(memory.memories).to eq({ 123 => String })
      end

      it 'can be flushed' do
        memory.flush_memories!
        expect(memory.memories).to eq({})
      end
    end
  end

  context '.with_memories' do
    context 'when has memories about object' do
      before { memory.remember!(String, 123) }

      it 'returns that object' do
        result = memory.with_memories(123)
        expect(result).to eq(String)
      end
    end

    context 'when does not have any memories about object' do
      it 'takes a block, evaluates it and returns its result' do
        expect {
          memory.with_memories(123) { raise 'raised' }
        }.to raise_error('raised')
      end
    end
  end
end
