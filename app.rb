#!/usr/bin/env ruby

ENV['RACK_ENV'] ||= 'production'
ENV['WEBSOCKET_PORT'] ||= '8000'

require 'bundler'
Bundler.require :default, ENV['RACK_ENV'].to_sym

Faye::WebSocket.load_adapter('thin')

class Ecotone < Sinatra::Base

    set :root, File.dirname(__FILE__)
    set :public_folder, File.dirname(__FILE__) + '/static'
    set :server, :thin

    enable :sessions

    def initialize(app = nil, params = {})
      super(app)
      @clients = []
    end

    index = lambda do
        erb :index
    end

    messages = lambda do
        if Faye::WebSocket.websocket?(request.env)
            ws = Faye::WebSocket.new(request.env)

            ws.on(:open) do |event|
              puts 'WS open triggered'
              @clients << ws
            end

            ws.on(:message) do |msg|
                if msg.data == 'pstree'
                    ws.send(`pstree`)
                end

                # look into eventmachine-tail
                if msg.data == 'log'
                    @clock = Thread.new { loop { ws.send(Time.now.to_s); sleep(1) } }
                end

                @clients.each do |client|
                  puts 'Sending message: ' + msg.data
                  client.send(msg.data)
                end
            end

            ws.on(:close) do |event|
              puts 'WS close triggered'
              @clients.delete(ws)
              ws = nil
            end

            ws.rack_response
        else
            status 200
            body ''
        end
    end

    get '/', &index
    get '/messages', &messages

end
