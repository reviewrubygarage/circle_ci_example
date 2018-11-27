require 'pry'
RSpec.describe SwgemWrapper::ScriptGenerator do
  let(:subject) { described_class.new }
  let(:person_path) { 'people/1/' }
  let(:planets_path) { 'planets/1/' }
  let(:starships_path) { 'starships/1/' }
  let(:john) { 'John' }
  let(:plane) { 'plane' }
  let(:earth) { 'Earth' }
  let(:person_response) do
    double('Person Response',
           body: JSON.generate({ 'name' => john }),
           status: status
    )
  end
  let(:starships_response) do
    double('Starship Response',
           body: JSON.generate({ 'name' => plane }),
           status: status
    )
  end
  let(:planets_response) do
    double('Planet Response',
           body: JSON.generate({ 'name' => earth }),
           status: status
    )
  end
  let(:connection_double) { double('Connection') }

  describe '#generate_random_script' do
    context 'returns script' do
      let(:status) { 200 }
      before do
        allow(subject).to receive(:connection) { connection_double }
        stub_const("SwgemWrapper::ScriptGenerator::RANDOM_ID_RANGE", [1])
        allow(connection_double).to receive(:get).with(person_path) { person_response }
        allow(connection_double).to receive(:get).with(planets_path) { planets_response }
        allow(connection_double).to receive(:get).with(starships_path) { starships_response }
      end

      it do
        result = subject.generate_random_script
        expect(result).to match(john)
        expect(result).to match(plane)
        expect(result).to match(earth)
      end
    end

    context 'raise exception' do
      let(:error_message) { 'Error message' }

      before do
        allow(subject).to receive(:connection) { connection_double }
        stub_const("SwgemWrapper::ScriptGenerator::RANDOM_ID_RANGE", [1])
        allow(connection_double).to receive(:get).with(person_path) { person_response }
        allow(connection_double).to receive(:get).with(planets_path) { planets_response }
        allow(connection_double).to receive(:get).with(starships_path) { starships_response }
      end

      context 'NotFoundError' do
        let(:status) { 404 }

        it do
          result = subject.generate_random_script
          expect(result).to match(SwgemWrapper::NotFoundError.to_s)
        end
      end

      context 'InternalServerError' do
        let(:status) { 500 }

        it do
          result = subject.generate_random_script
          expect(result).to match(SwgemWrapper::InternalServerError.to_s) 
          expect(result).to match('Internal server error for') 
        end
      end
    end
  end
end
