require 'scrawls/ioengine/single/version'
require 'scrawls/ioengine/base'
require 'socket'
require 'mime-types'

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
          response = handle request

          close
        end
      end

      def send_data data
        Thread.current[:connection].write data
      end

      def close
        Thread.current[:onnection].close
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
