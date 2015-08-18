require 'spec_helper'

describe UsersController, type: :controller do
  subject(:stored_binding) { StoredBinding.last.stored_binding }

  context 'dumping AR objects' do
    before(:each) do
      5.times { |i| User.create(email: "email#{i}@email.email") }
    end

    before { get :index }
    subject(:relation) { stored_binding.eval('@users') }

    it 'dumps whole relation' do
      expect(relation.count).to eq(5)
      expect(relation.first).to eq(User.first)
    end
  end

  context 'dumping local vars' do
    before { get :index }
    subject(:local) { stored_binding.eval('some_proc') }

    it 'dumps local vars (which can also be procs)' do
      expect(local.call).to eq(2)
    end
  end

  context 'dumping rails-related stuff' do
    context 'params' do
      before { get :index, limit: 10 }

      subject(:params) { stored_binding.eval('params') }

      it 'returns controller params, not hash' do
        expect(params).to be_a(ActionController::Parameters)
      end

      it 'contains provided request params' do
        expect(params[:limit]).to eq('10')
      end
    end

    context 'response' do
      before do
        User.create(email: 'test@email.com')
        get :index
      end

      let(:raw_response) { stored_binding.eval('response') }
      subject(:response) { JSON.parse(raw_response.body) }

      it 'returns existing users' do
        expect(response).to be_an(Array)
        expect(response.length).to eq(1)
      end
    end
  end
end
