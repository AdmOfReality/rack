class TimeApp
  AVAILABLE_FORMATS = {
    'year' => '%Y',
    'month' => '%m',
    'day' => '%d',
    'hour' => '%H',
    'minute' => '%M',
    'second' => '%S'
  }.freeze

  def call(env)
    request = Rack::Request.new(env)

    if request.path == '/time' && request.get?
      handle_time_request(request)
    else
      response(404, 'Not Found')
    end
  end

  private

  def handle_time_request(request)
    formats = request.params['format']&.split(',')

    if formats.nil? || formats.empty?
      return response(400, 'Format is empty')
    end

    unknown_formats = formats.reject { |format| AVAILABLE_FORMATS.key?(format) }

    if unknown_formats.any?
      response(400, "Unknown time format [#{unknown_formats.join(', ')}]")
    else
      time_string = formats.map { |format| AVAILABLE_FORMATS[format] }.join('-')
      response(200, Time.now.strftime(time_string))
    end
  end

  def response(status, body)
    [status, { 'content-type' => 'text/plain' }, [body]]
  end
end
