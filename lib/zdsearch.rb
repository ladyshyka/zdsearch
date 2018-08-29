require_relative 'zdsearch/version'
require_relative 'zdsearch/data_store'
require_relative 'zdsearch/search_responder'
require_relative 'zdsearch/config'
require 'hashie'
require 'json'

module ZDSearch

  class ZDSearchHandler
    attr_reader :data_store, :options

    def initialize(config, options = {})
      Config.set_config(config)
      @data_store = DataStore.new
      @options = options
    end

    def run
      # pre run files
      begin
        DataStore.organizations_data
        DataStore.users_data
        DataStore.tickets_data
      rescue => e
        puts "#{e}"
        return
      end

      result = @data_store.search_by(
        {
          :filter => options[:type],
          :keyword => options[:keyword],
          :field => options[:field]
        })
      puts result.prettify_str
    end

  end
end
