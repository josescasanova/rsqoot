require "rsqoot/client"

# load Rails/Railtie
begin
  require 'rails'
rescue LoadError
  #do nothing
end

module RSqoot

  class << self
    attr_accessor :public_api_key, :private_api_key, :base_api_url, :authentication_method, :read_timeout

    # Configure default credentials easily
    #
    # @yield [RSqoot]
    def configure
      load_defaults
      yield self
      raise "You must add your own public api key to initializer ." if self.public_api_key.empty?
      raise "You must add your own private api key to initializer ." if self.private_api_key.empty?
      raise "Authentication method must be :header or :parameter ." if !AUTHENTICATION_METHODS.include? self.authentication_method
      true
    end

    def load_defaults
      self.base_api_url ||= "https://api.sqoot.com"
      self.authentication_method = :header
      self.read_timeout = 60
    end

    private

    AUTHENTICATION_METHODS = [:header, :parameter]

  end

end
