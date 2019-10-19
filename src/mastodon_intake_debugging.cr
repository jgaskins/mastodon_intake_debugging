require "http"
require "json"

module MastodonIntakeDebugging
  VERSION = "0.1.0"
end

server = HTTP::Server.new do |context|
  request = context.request

  pp(
    method: request.method,
    path: request.path,
    headers: request.headers,
    query: request.query_params,
  )

  if context.request.headers["Content-Type"]? =~ /json/
    case body = request.body
    when String
      pp json: JSON.parse(body)
    when IO
      pp json: JSON.parse(body.gets_to_end)
    end
  else
    pp body: request.body
  end

  # Try to get the calling instance to rerun this request
  context.response.status = HTTP::Status::INTERNAL_SERVER_ERROR
end

server.listen "0.0.0.0", ENV.fetch("PORT") { "5000" }.to_i
