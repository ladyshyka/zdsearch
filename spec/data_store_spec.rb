RSpec.describe ZDSearch::DataStore do

  context 'DataStore' do
    let(:data_store) { described_class }

    before {
      allow(ZDSearch::Config).to receive(:organizations_file).and_return('./spec/fixtures/organizations.json')
      allow(ZDSearch::Config).to receive(:users_file).and_return('./spec/fixtures/users.json')
      allow(ZDSearch::Config).to receive(:tickets_file).and_return('./spec/fixtures/tickets.json')
    }

    after { ZDSearch::DataStore.new }

    subject { data_store }

    describe '#read_organization' do

      it 'reads and stores organizations' do
        expect(data_store.organizations_data.count).to eq 25
      end

    end

    describe '#read_users' do

      it 'reads and stores users' do
        expect(subject.users_data.count).to eq 75
      end

    end

    describe '#read_tickets' do

      it 'reads and stores tickets' do
        expect(subject.tickets_data.count).to eq 200
      end

    end

    describe '#search_by' do

      let(:keyword) { nil }
      let(:filter) { nil }
      let(:field) { nil }

      subject { data_store.new().search_by({:keyword => keyword, :filter => filter, :field => field}) }

      context 'all' do
        let(:keyword) { nil }

        before { expect(ZDSearch::SearchResponder).to receive(:report).with(array_of_size(25), array_of_size(75), array_of_size(200)) }

        it 'will find everything when nothing is specified' do
          subject
        end

      end

      context 'empty description' do
        let(:keyword) { nil }
        let(:field) { 'description' }
        let(:filter) { 'tickets' }

        before { expect(ZDSearch::SearchResponder).to receive(:report).with(nil, nil, array_of_size(1)) }

        it 'can search on empty fields' do
          subject
        end

      end

      context 'organizations' do
        let(:keyword) { 'Artisan' }
        let(:filter) { 'organizations' }
        let(:array_size) { 4 }

        before { expect(ZDSearch::SearchResponder).to receive(:report).with(array_of_size(array_size), nil, nil) }

        it 'can find organizations by keyword' do
          subject
        end

        context 'with field' do
          let(:field) { 'name' }
          let(:keyword) { 'Comtext' }
          let(:array_size) { 1 }

          it 'can find organizations by specified name' do
            subject
          end

        end

        context 'with field on an array' do
          let(:field) { 'tags' }
          let(:keyword) { 'Wall' }
          let(:array_size) { 1 }

          it 'can find organizations by specified tag' do
            subject
          end

        end

      end

      context 'users' do
        let(:filter) { 'users' }
        let(:keyword) { 'Coffey' }
        let(:array_size) { 1 }

        before { expect(ZDSearch::SearchResponder).to receive(:report).with(nil, array_of_size(array_size), nil) }

        it 'can find users by keyword' do
          subject
        end

      end

      context 'tickets' do
        let(:filter) { 'tickets' }
        let(:keyword) { 'New York' }
        let(:array_size) { 14 }

        before { expect(ZDSearch::SearchResponder).to receive(:report).with(nil, nil, array_of_size(array_size)) }

        it 'can find tickets by keyword' do
          subject
        end

      end

    end

  end

end