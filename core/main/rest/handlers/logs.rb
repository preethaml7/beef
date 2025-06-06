#
# Copyright (c) 2006-2025 Wade Alcorn - wade@bindshell.net
# Browser Exploitation Framework (BeEF) - https://beefproject.com
# See the file 'doc/COPYING' for copying permission
#

module BeEF
  module Core
    module Rest
      class Logs < BeEF::Core::Router::Router
        config = BeEF::Core::Configuration.instance

        before do
          error 401 unless params[:token] == config.get('beef.api_token')
          halt 401 unless BeEF::Core::Rest.permitted_source?(request.ip)
          headers 'Content-Type' => 'application/json; charset=UTF-8',
                  'Pragma' => 'no-cache',
                  'Cache-Control' => 'no-cache',
                  'Expires' => '0'
        end

        #
        # @note Get all global logs
        #
        get '/' do
          logs = BeEF::Core::Models::Log.all
          logs_to_json(logs)
        end

        #
        # @note Get all global logs
        #
        get '/rss' do
          logs = BeEF::Core::Models::Log.all
          headers 'Content-Type' => 'text/xml; charset=UTF-8',
                  'Pragma' => 'no-cache',
                  'Cache-Control' => 'no-cache',
                  'Expires' => '0'
          logs_to_rss logs
        end

        #
        # @note Get hooked browser logs
        #
        get '/:session' do
          hb = BeEF::Core::Models::HookedBrowser.where(session: params[:session]).first
          error 401 if hb.nil?

          logs = BeEF::Core::Models::Log.where(hooked_browser_id: hb.id)
          logs_to_json(logs)
        end

        private

        def logs_to_json(logs)
          logs_json = []
          count = logs.length

          logs.each do |log|
            logs_json << {
              'id' => log.id.to_i,
              'date' => log.date.to_s,
              'event' => log.event.to_s,
              'logtype' => log.logtype.to_s,
              'hooked_browser_id' => log.hooked_browser_id.to_s
            }
          end

          unless logs_json.empty?
            {
              'logs_count' => count,
              'logs' => logs_json
            }.to_json
          end
        end

        def logs_to_rss(logs)
          rss = RSS::Maker.make('atom') do |maker|
            maker.channel.author  = 'BeEF'
            maker.channel.updated = Time.now.to_s
            maker.channel.about   = 'https://beefproject.com/'
            maker.channel.title   = 'BeEF Event Logs'

            logs.reverse.each do |log|
              maker.items.new_item do |item|
                item.id      = log.id.to_s
                item.title   = "[#{log.logtype}] #{log.event}"
                item.updated = log.date.to_s
              end
            end
          end
          rss.to_s
        end
      end
    end
  end
end
