RSpec.describe SwgemWrapper::ScriptGenerator do
  context '#random_script' do
    it 'retuns Petya' do
      expect(!!subject.random_script).to eq true
    end
  end
end
