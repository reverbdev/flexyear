require 'flexyear/range_parsers/range_parser'
require 'flexyear/range_parsers/early_parser'
require 'flexyear/range_parsers/mid_parser'
require 'flexyear/range_parsers/late_parser'
require 'flexyear/range_parsers/before_parser'
require 'flexyear/range_parsers/decade_parser'
require 'flexyear/range_parsers/year_range_parser'
require 'flexyear/range_parsers/circa_parser'
require 'flexyear/range_parsers/reissue_parser'
require 'flexyear/range_parsers/specific_year_parser'
require 'flexyear/version'
require 'date'

# Represents a flexible year entry:
#
#  * 1979 - a specific year
#  * 1970s and 70s - decades
#  * mid-70s, early-70s, late-70s - subdecades, dashes optional
#  * 1972-1975 - a range
#
# All years can be in two or four digit format
class FlexYear
  class InvalidYearError < ArgumentError; end

  attr_reader :year_low, :year_high

  def initialize(year_string)
    @year_string = year_string.to_s

    @low, @high = RangeParser.parse(@year_string)

    parse_year
  end

  def to_s
    @year_string
  end

  private

  def centuryize(year, base_year=nil)
    base = "19" # 19th century
    if base_year
      base = (base_year/100).to_s
    end

    if year.length == 1
      "#{base}0#{year}"
    elsif year.length == 2
      "#{base}#{year}"
    else
      year
    end
  end

  def parse_year
    if @year_string =~ /(\d+)\s*-\s*(\d+)/ && $1 && $2
      @year_low = centuryize($1).to_i
      @year_high = centuryize($2, @year_low).to_i
    else
      if @year_string =~ /(\d+).*s$/
        @base_year = centuryize($1).to_i
      elsif @year_string =~ /^\w+\s+(\d+)/
        @base_year = centuryize($1).to_i
      else
        @base_year = @year_string.gsub(/\D+/,'').to_i
      end

      if @base_year > 9999
        raise InvalidYearError, "Please use a four digit year."
      end

      @year_low = @base_year + (@low || 0)
      @year_high = @base_year + (@high || 0)
    end
  end

  # Represents a flexible year entry that must be in the past.
  class Historical < FlexYear
    private

    def parse_year
      super

      if @base_year > DateTime.now.year
        raise InvalidYearError, "The year must be in the past. You specified #{@base_year}; Today is #{DateTime.now.year}"
      end
    end
  end
end
