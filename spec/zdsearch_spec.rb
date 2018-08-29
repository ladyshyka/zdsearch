RSpec.describe ZDSearch do
  it 'has a version number' do
    expect(ZDSearch::VERSION).not_to be nil
  end

  context 'ZDSearchHandler' do
    let(:config_file) { 'some_yml' }
    let(:options) { {} }

    before do
      allow(ZDSearch::Config).to receive(:organizations_file).and_return(nil)
      allow(ZDSearch::Config).to receive(:users_file).and_return(nil)
      allow(ZDSearch::Config).to receive(:tickets_file).and_return(nil)

      ZDSearch::DataStore.new()
      ZDSearch::DataStore.remove_instance_variable(:@organizations_data) if ZDSearch::DataStore.instance_variable_defined?(:@organizations_data)
      ZDSearch::DataStore.remove_instance_variable(:@users_data) if ZDSearch::DataStore.instance_variable_defined?(:@users_data)
      ZDSearch::DataStore.remove_instance_variable(:@tickets_data) if ZDSearch::DataStore.instance_variable_defined?(:@tickets_data)
    end

    subject { ZDSearch::ZDSearchHandler.new('config_file', options)}

    describe '#run' do
      it 'errors out gracefully on invalid Organization file' do
        expect(STDOUT).to receive(:puts).with('Organization JSON File Invalid. Please check your config')
        subject.run
      end
    end

  end

end
