# frozen_string_literal: true

require 'utils'

module GoogleApiMock
  class CellData
    attr_reader :formatted_value, :user_entered_value, :effective_value

    DATE_FORMAT = '%d/%m/%y'
    ExtendedValue = Struct.new(:number_value, :string_value, :bool_value, :formula_value)

    def initialize(value, format)
      return if value == ''

      @format = format
      @formatted_value = formatted_value_for(value)
      @user_entered_value = ExtendedValue.new(*extended_value_params(value))
      @effective_value = @user_entered_value
    end

    private

    def formatted_value_for(value)
      return value.to_s if @format == :text || !value.is_a?(Numeric)
      return AspireBudget::Utils.parse_date(value).strftime('%-d/%-m/%y') if @format == :date

      "$#{format('%<value>.2f', value: value)}"
    end

    def extended_value_params(value)
      return [value.to_f, nil, nil, nil] if value.is_a?(Numeric)

      case @format
      when :date
        date = Date.strptime(value, DATE_FORMAT)
        value = AspireBudget::Utils.serialize_date(date)
        [value, nil, nil, nil]
      when :currency
        value = value.gsub(/[€$,]/, '').to_f
        [value, nil, nil, nil]
      else
        guess_extended_value(value)
      end
    end

    def guess_extended_value(value)
      if value.to_f.to_s == value.to_s || value.to_i.to_s == value.to_s
        [value.to_f, nil, nil, nil]
      else
        [nil, value, nil, nil]
      end
    end
  end
end
