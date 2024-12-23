# frozen_string_literal: true

# Time Formatter
module Formatter
  OPTIONS = Set['year', 'month', 'day', 'hour', 'minute', 'second']
  OPT_ARRAY = OPTIONS.to_a
  FORMATS = ['%Y', '%m', '%d', '%H', '%M', '%S'].freeze

  # converts "year day minute" into "%Y %d %M"
  def self.convert(options)
    line = options.to_a.map { |el| FORMATS[OPT_ARRAY.index(el)] }.join(' ')
    Time.now.strftime line
  end
end
