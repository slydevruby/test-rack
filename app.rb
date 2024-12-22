# frozen_string_literal: true

# New Application
class App
  OPTIONS = Set['year', 'month', 'day', 'hour', 'minute', 'second']
  FORMATS = ['%Y', '%m', '%d', '%H', '%M', '%S'].freeze

  def call(env)
    format, options = env['QUERY_STRING'].split('=')
    if env['REQUEST_METHOD'] == 'GET' && env['REQUEST_PATH'] == '/time' && format == 'format'
      parse(options)
    else
      [404, headers, []]
    end
  end

  private

  def headers
    { 'content-type' => 'text/plain' }
  end

  def convert(options)
    options_array = OPTIONS.to_a
    line = options.to_a.map.each do |el|
      FORMATS[options_array.index(el)]
    end.join(' ')
    "#{line}\n"
  end

  def parse(options)
    options = options.split('%2C').to_set
    invalid_options = (options - OPTIONS).join(' ')
    if invalid_options.empty?
      [200, headers, [Time.now.strftime(convert(options))]]
    else
      [400, headers, ["Unknown time format [#{invalid_options}]\n"]]
    end
  end
end
