module Frest
  class Server
    require 'rack'
    require 'frest/google_authorizer'

    def self.start
      new.start
    end

    def start
      # client = Rack::OAuth2::Client.new(
      #   identifier: ENV['client_id'],
      #   secret: ENV['client_secret'],
      #   redirect_uri: ENV['redirect_uri'],
      #   host: ENV['host']
      # )

      app = Proc.new do |env|
        req = Rack::Request.new(env)
        token = Frest::GoogleAuthorizer.authorize(req)

        ['200', {'Content-Type' => 'text/html'}, [Frest::GoogleAuthorizer::login_page]]
      end


      Rack::Handler::WEBrick.run(
          app,
          Port: ENV['port'], Host: ENV['local_host'])
    end
  end
end
