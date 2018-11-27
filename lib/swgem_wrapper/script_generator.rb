module SwgemWrapper
  class ScriptGenerator
    RANDOM_ID_RANGE = (1..20).to_a
    PEOPLE = 'people'.freeze
    PLANETS = 'planets'.freeze
    STARSHIPS = 'starships'.freeze

    def initialize
      @errors = {}
    end

    def generate_random_script
      script = "#{person['name']} from #{planet['name']} decides to repair #{starship['name']} and travel to #{planet['name']}"
      errors.empty? ? script : errors.to_s
    end

    private

    attr_accessor :errors

    def person
      fetch_resource(PEOPLE)
    end
  
    def planet
      fetch_resource(PLANETS)
    end

    def starship
      fetch_resource(STARSHIPS)
    end

    def fetch_resource(path)
      make_get_request(path)
    rescue NotFoundError, InternalServerError => error
      errors.store(error.class.to_s, error.message)
      {}
    end

    def make_get_request(path)
      id = random_id
      response = connection.get("#{path}/#{id}/")
      case response.status
      when 200 then parse(response.body)
      when 404 then raise NotFoundError.new("#{path} with #{id}: #{parse(response.body)['detail']}")
      when 500 then raise InternalServerError.new("Internal server error for /#{path}/#{id}")
      end
    end

    def random_id
      RANDOM_ID_RANGE.to_a.sample
    end

    def parse(body)
      JSON.parse(body)
    end

    def connection
      @connection ||= Faraday.new(:url => BASE_URL) do |faraday|
        faraday.request :url_encoded
        faraday.adapter Faraday.default_adapter
      end
    end
  end
end
