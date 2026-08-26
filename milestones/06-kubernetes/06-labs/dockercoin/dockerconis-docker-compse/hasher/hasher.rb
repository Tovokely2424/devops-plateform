require 'digest'
require 'sinatra'
require 'socket'

set :port, ENV.fetch('PORT', 80)

post '/' do
    sleep ENV.fetch('DELAY', 0.1).to_f

    content_type 'text/plain'

    "#{Digest::SHA2.new().update(request.body.read)}"
end

