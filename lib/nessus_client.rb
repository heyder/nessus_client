require_relative 'nessus_client/version'
require_relative 'nessus_client/exception'

Dir[File.join(__dir__, 'modules', '*.rb')].each { |file| require file }

class NessusClient

  attr_reader :request, :session, :headers
  
  include NessusClient::Session
  include NessusClient::Scans
  include NessusClient::Exports
  include NessusClient::Folders
  include NessusClient::Policies

  autoload :Request, "nessus_client/request"

  # @param [Hash] params the options to create a NessusClient with.
  # @option params [String] :uri ('https://localhost:8834/') Nessus endpoint to connect with
  # @option params [String] :username Username (nil) to use in the connection
  # @option params [String] :password Password (nil) to use in the connection
  # @option params [String] :ssl_verify_peer (false) should check whether valid SSL certificate
  def initialize( params = {} )
    
    default_params = { 
      uri: 'https://localhost:8834/', 
      username: nil, 
      password: nil, 
      ssl_verify_peer: true
    }
    params = default_params.merge( params )
    req_params = params.select {|key, value| [:uri, :ssl_verify_peer].include?(key) } 

    @request = NessusClient::Request.new( req_params )
    @headers = NessusClient::Request::DEFAULT_HEADERS.dup
    self.set_session( params.fetch(:username), params.fetch(:password) )


  end

  # Gets NessusClient::Session authentication status.
  # @return [Boolean]
  def has_session?
    self.session
  end

  # Gets the server status.
  # @return [Json] Returns the server status (loading, ready, corrupt-db, feed-expired, eval-expired, locked, register, register-locked, download-failed, feed-error).
  def status
    self.request.get( {:path => "/server/status", :headers => self.headers} )
  end

end