require 'scrawls/ioengine/single/version'
require 'scrawls/ioengine/base'
require 'socket'
require 'mime-types'
if RUBY_PLATFORM =~ /linux/
  require 'scrawls/ioengine/single/enable_tcp_cork'
else
  require 'scrawls/ioengine/single/disable_tcp_cork'
end

module Scrawls
  module Ioengine
    class Single < Scrawls::Ioengine::Base

      def initialize(scrawls)
        @scrawls = scrawls
      end

      def run( config = {} )
        server = TCPServer.new( config[:host], config[:port] )

        do_main_loop server
      end

      def do_main_loop server
        while connection = server.accept
          Thread.current[:connection] = connection
          request = get_request connection
          cork_tcp_socket connection
          response = handle request
          uncork_tcp_socket connection

          close
        end
      end

      def send_data data
        Thread.current[:connection].write data
      end

      def close
        Thread.current[:connection].close
      end

      def get_request connection
        http_engine_instance = @scrawls.http_engine.new @scrawls
        r = ''
        while !http_engine_instance.done?
          line = connection.gets
          break if line.nil?
          http_engine_instance.receive_data line
        end

        if http_engine_instance.done?
          http_engine_instance.env
        else
          # TODO: Some error handling
          nil
        end
      end

      def handle request
        if request
          @scrawls.process request, self
        else
          @scrawls.deliver_400 self
        end
      end

    end
  end
end
