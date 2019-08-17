require 'oj'
require_relative 'request'
require_relative 'exception'

class NessusApi

  # This class should be used to get an access token
  # for use with the main client class.
  class Session
    attr_reader :token, :api_token

    @token      = nil
    @api_token  = nil

    # @param [String] username
    # @param [String] password
    def self.create( username, password )
      
      payload = {
        username: username,
        password: password,
      }

      response = NessusApi::Request.post( '/session', payload )
      response = Oj.load(response) if response.length > 0

      if response['token']
         return self.new( response['token'] )
      else
        raise NessusApi::Error.new "Response did not include a session token."
      end

    end

    def initialize( token )      
      @token = token
    end

    def get_api_token
      response = NessusApi::Request.get( "/nessus6.js" )
      response.match( %r{return"(\w{8}-(?:\w{4}-){3}\w{12})"\}} )
      
      @api_token = $1 ? $1 : nil

      raise NessusApi::Error.new( "Unable to get API Token. Some features won't work." ) if @api_token.nil?
      
    end

    def destroy
      NessusApi::Request.delete( '/session', nil )
      @token = nil
    end
    alias_method :logout , :destroy

  end

end