module ZDSearch
  class DataStore

    def initialize
      @organizations_data = nil
      @users_data = nil
      @tickets_data = nil
    end

    def self.organizations_data
      begin
        @organizations_data ||= JSON.parse(File.read(Config.organizations_file)).extend(Hashie::Extensions::DeepLocate)
      rescue
        raise "Organization JSON File Invalid. Please check your config"
      end
    end

    def self.users_data
      begin
        @users_data ||= JSON.parse(File.read(Config.users_file)).extend(Hashie::Extensions::DeepLocate)
      rescue
        raise "Users JSON File Invalid. Please check your config"
      end
    end

    def self.tickets_data
      begin
        @tickets_data ||= JSON.parse(File.read(Config.tickets_file)).extend(Hashie::Extensions::DeepLocate)
      rescue
        raise "Tickets JSON File Invalid. Please check your config"
      end
    end

    def search_by(options = {})
      filter = options[:filter]
      keyword = options[:keyword]
      field = options[:field]

      if filter.nil? && keyword.nil? && field.nil?
        return SearchResponder.report(DataStore.organizations_data, DataStore.users_data, DataStore.tickets_data)
      end

      if filter.nil? || filter.include?('organizations')
        organizations = perform_search(DataStore.organizations_data, keyword, field)
      end

      if filter.nil? || filter.include?('users')
        users = perform_search(DataStore.users_data, keyword, field)
      end

      if filter.nil? || filter.include?('tickets')
        tickets = perform_search(DataStore.tickets_data, keyword, field)
      end

      SearchResponder.report(organizations, users, tickets)
    end

    private

    def perform_search(search_data, keyword, field)
      search_data.deep_locate -> (f, v, o) do
        if keyword
          (v.is_a?(Array) && f == field && v.include?(keyword)) ||
           ((field ? f == field : true) && v.is_a?(String) && v.include?(keyword))
        else
          f == field && (v.to_s.empty?)
        end
      end
    end
  end

end