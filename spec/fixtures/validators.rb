module Fixtures
  module Validators
    class LongerThan3 < Moon::DataModel::Validators::Base
      def test_valid(obj)
        obj.length > 3
      end

      register :longer_than3
    end
  end
end
