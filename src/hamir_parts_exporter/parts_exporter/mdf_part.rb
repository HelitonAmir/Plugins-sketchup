module HamirTools

  class MDFPart

    attr_reader :component, :name, :long_side, :short_side, :thickness, :grain_direction
    attr_accessor :melamine, :edge_length1, :edge_length2, :edge_width1, :edge_width2

    GRAIN_DIRECTIONS = [:LENGTHWISE, :WIDTHWISE, :IGNORE_GRAIN].freeze
    MDF_THICKNESSES = [6, 15, 18].freeze
    DEFAULT_MELAMINE = "Branco TX".freeze

    def initialize(component, name, short_side, long_side, thickness, grain_direction)

      raise ArgumentError, "Orientação de corte inválida: #{grain_direction}" unless GRAIN_DIRECTIONS.include?(grain_direction)
      raise ArgumentError, "Espessura inválida: #{thickness}" unless MDF_THICKNESSES.include?(thickness)
      raise ArgumentError, "Lado menor(#{short_side}) > Lado maior(#{long_side})" unless short_side <= long_side

      @component = component
      @name = name
      @long_side = long_side.to_i
      @short_side = short_side.to_i
      @thickness = thickness.to_i
      @grain_direction = grain_direction

      @melamine = DEFAULT_MELAMINE
      @edge_length1 = false
      @edge_length2 = false
      @edge_width1 = false
      @edge_width2 = false
    end

    def width
      grain_direction == :WIDTHWISE ? long_side : short_side
    end

    def length
      grain_direction == :WIDTHWISE ? short_side : long_side
    end

    def ignore_grain
      grain_direction == :IGNORE_GRAIN
    end

    def self.valid_thickness?(value)
      MDF_THICKNESSES.any? { |t| value == t}
    end

  end # MDFPart
end # module HamirTools
