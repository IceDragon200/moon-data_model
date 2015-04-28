require 'data_model/err'

module Moon
  module DataModel
    class Type
      # @!attribute [r] model
      #   @return [Module] the main class of the type
      attr_reader :model
      # @!attribute [r] content
      #   @return [Hash, Array, nil] depending on the model
      attr_reader :content

      # @param [Module] model
      # @param [Object] content
      # @param [Hash] options
      # @option options [Boolean] :array
      # @option options [Boolean] :hash
      # @option options [Boolean] :incomplete
      def initialize(model, content = nil, options = {})
        @model = model
        @content = content.presence
        @array = options.fetch(:array, false)
        @hash = options.fetch(:hash, false)
        @incomplete = options.fetch(:incomplete, false)
      end

      # Attempts to complete the Type, returns self if the type is already
      # complete, else returns a new Type.
      #
      # @return [Type, self]
      def finalize
        if @incomplete
          new_model = Object.const_get(@model)
          return Type[new_model]
        end
        self
      end

      # Checks if the Type has been completed, if not raises an IncompleteType
      # error.
      # @api private
      def check_complete
        raise IncompleteType, "incomplete type #{@model}" if @incomplete
      end

      # Is this Type an Array?
      #
      # @return [Boolean]
      def array?
        @array
      end

      # Is this Type a Hash/Map/Dict?
      #
      # @return [Boolean]
      def hash?
        @hash
      end

      # Is this Type incomplete?
      #
      # @return [Boolean]
      def incomplete?
        @incomplete
      end

      private def coerce_array(obj)
        if @content
          # TODO, maybe enforce one content type?
          klass = @content.first
          t = Type[klass]
          obj.map { |o| t.coerce(o) }
        else
          Array[obj]
        end
      end

      private def coerce_hash(obj)
        if @content
          # TODO, maybe enforce one content type?
          k, v = *@content.first
          k, v = Type[k], Type[v]
          obj.each_with_object({}) do |p, r|
            pk = k.coerce(p[0])
            pv = v.coerce(p[1])
            r[pk] = pv
          end
        else
          Hash[obj]
        end
      end

      # @param [Object] obj
      # @return [Object]
      def coerce(obj)
        check_complete
        # Does the type define its own coerce method?
        if @model.respond_to?(:coerce)
          @model.coerce(obj)
        # is the type an Array
        elsif @array
          coerce_array(obj)
        # is the type a Hash
        elsif @hash
          coerce_hash(obj)
        else
          obj
        end
      end

      # @return [Hash<Object, Type>]
      def self.types
        @types ||= {}
      end

      def self.[](type)
        types[type] ||= begin
          case type
          when Array
            new Array, type, array: true
          when Hash
            new Hash, type, hash: true
          when String
            new type, nil, incomplete: true
          when Module
            if type == Array
              new type, nil, array: true
            elsif type == Hash
              new type, nil, hash: true
            else
              new type
            end
          else
            raise InvalidModelType, "cannot create Type from #{type}"
          end
        end
      end
    end
  end
end
