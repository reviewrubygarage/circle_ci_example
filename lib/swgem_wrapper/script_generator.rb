module SwgemWrapper
  class ScriptGenerator
    def random_script
      "#{person} from #{planet} decides to repair #{starship} and travel to #{planet}"
    end

    private

    def person
      if 1 == [1,2].sample
        'Petya'
      else
        'Vasya'
      end
    end

    def planet
      if 1 == [1,2].sample
        'Petya'
      else
        'Vasya'
      end
    end

    def starship
      if 1 == [1,2].sample
        'Petya'
      else
        'Vasya'
      end
    end
  end
end
