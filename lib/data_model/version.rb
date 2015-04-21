module Moon
  module DataModel
    module Version
      MAJOR, MINOR, TEENY, PATCH = 1, 0, 0, nil
      STRING = [MAJOR, MINOR, TEENY, PATCH].compact.join('.')
    end
    VERSION = Version::STRING
  end
end
