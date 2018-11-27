module SwgemWrapper
  class ScriptGenerator
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
      make_get_request(PEOPLE, random_id)
    rescue NotFoundError, InternalServerError => error
      errors.store(error.class.to_s, error.message)
      {}
    end
  
    def planet
      make_get_request(PLANETS, random_id)
    rescue NotFoundError, InternalServerError => error
      errors.store(error.class.to_s, error.message)
      {}
    end

    def starship
      make_get_request(STARSHIPS, random_id)
    rescue NotFoundError, InternalServerError => error
      errors.store(error.class.to_s, error.message)
      {}
    end

    def random_id
      (1..20).to_a.sample
    end

    def parse(body)
      JSON.parse(body)
    end

    def make_get_request(path, id)
      response = connection.get("#{path}/#{random_id}/")
      case response.status
      when 200 then parse(response.body)
      when 404 then raise NotFoundError.new("#{path} with #{id}: #{parse(response.body)['detail']}")
      when 500 then raise InternalServerError.new("Internal server error for /#{path}/#{id}")
      end
    end

    def connection
      @connection ||= Faraday.new(:url => BASE_URL) do |faraday|
        faraday.request :url_encoded
        faraday.adapter Faraday.default_adapter
      end
    end
  end
end
