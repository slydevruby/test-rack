# frozen_string_literal: true

require_relative 'formatter'

# New Application
class App
  DELIMITER = '%2C'
  TEXT_STATUS = { not_found: 'Not found', bad_request: 'Unknown time format ' }.freeze
  STATUS = { ok: 200, not_found: 404, bad_request: 400 }.freeze

  def call(env)
    unless accept? env
      response :not_found, TEXT_STATUS[:not_found]
      return
    end

    valid, invalid = parse_query(env)
    if invalid.empty?
      response(:ok, Formatter.convert(valid))
    else
      response(:bad_request, TEXT_STATUS[:bad_request] + invalid)
    end
  end

  def response(status, text)
    [STATUS[status], { 'content-type' => 'text/plain' }, ["#{text}\n"]]
  end

  private

  def accept?(env)
    format = env.fetch('QUERY_STRING').split('=')[0]
    env.fetch('REQUEST_METHOD') == 'GET' &&
      env.fetch('REQUEST_PATH') == '/time' &&
      format == 'format'
  end

  def parse_query(env)
    options = env.fetch('QUERY_STRING').split('=')[1].split(DELIMITER)
    [options, (options.to_set - Formatter::OPTIONS).join(' ')]
  end
end
