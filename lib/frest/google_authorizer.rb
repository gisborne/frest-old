module Frest
  module GoogleAuthorizer
    require 'googleauth'
    require 'googleauth/stores/file_token_store'
    require 'google-id-token'
    require 'frest/erb_file'

    @token_store = Google::Auth::Stores::FileTokenStore.new(file: 'logins')
    @client_id = Google::Auth::ClientId.new(
                    ENV['google_client_id'],
                    ENV['google_client_secret']
    )
    @login_page = Frest::ERBFile.new(client_id: @client_id).render('assets/html/google_login.html.erb')

    # configure do
    #   Google::Apis::ClientOptions.default.application_name = 'FREST'
    #   Google::Apis::ClientOptions.default.application_version = '0.9'
    #   Google::Apis::RequestOptions.default.retries = 3
    #
    #   enable :sessions
    #   set :show_exceptions, true
    #   set :client_id, Google::Auth::ClientId.new(ENV['google_client_id'],
    #                                              ENV['google_client_secret'])
    #   set :token_store, Google::Auth::Stores::FileTokenStore.new(file: 'logins')

    def authorize(req)
      return ['200', {'Content-Type' => 'text/html'}, ['WOOT']] if req.path == '/signed_in'

      audience  = @client_id.id
      # Important: The google-id-token gem is not production ready. If using, consider fetching and
      # supplying the valid keys separately rather than using the built-in certificate fetcher.
      validator = GoogleIDToken::Validator.new
      params = req.params

      claim     = validator.check(params['id_token'], audience, audience)
      if claim
        session = env['rack.session']

        session[:user_id]    = claim['sub']
        session[:user_email] = claim['email']
        200
      else
        # scopes =  ['https://www.googleapis.com/auth/cloud-platform', 'https://www.googleapis.com/auth/devstorage.read_only']
        #
        # Google::Auth::WebUserAuthorizer.new(
        #   client_id, scopes, @token_store, '/signed_in')
        ['200', {'Content-Type' => 'text/html'}, [@login_page]]
      end
    end

    def login_page
      @login_page
    end

    module_function :authorize
    module_function :login_page

    private

    def self.credentials_for(scope)
      authorizer = Google::Auth::WebUserAuthorizer.new(settings.client_id, scope, @token_store)
      user_id    = session[:user_id]
      redirect LOGIN_URL if user_id.nil?
      credentials = authorizer.get_credentials(user_id, request)
      if credentials.nil?
        redirect authorizer.get_authorization_url(login_hint: user_id, request: request)
      end
      credentials
    end
  end
end
