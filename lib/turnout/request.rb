require 'ipaddr'

module Turnout
  class Request
    def initialize(env)
      @action_dispatch_request = ActionDispatch::Request.new(env)
    end

    def allowed?(settings)
      path_allowed?(settings.allowed_paths) || ip_allowed?(settings.allowed_ips)
    end

    private

    attr_reader :action_dispatch_request

    def path_allowed?(allowed_paths)
      allowed_paths.any? do |allowed_path|
        action_dispatch_request.path =~ Regexp.new(allowed_path)
      end
    end

    def ip_allowed?(allowed_ips)
      begin
        ip = IPAddr.new(action_dispatch_request.remote_ip.to_s)
      rescue ArgumentError
        return false
      end

      allowed_ips.any? do |allowed_ip|
        IPAddr.new(allowed_ip).include? ip
      end
    end
  end
end
