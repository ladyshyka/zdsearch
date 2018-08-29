module ZDSearch
  class Config

    def self.set_config(conf)
      @organizations_file ||= conf["organizations_file"]
      @users_file ||= conf["users_file"]
      @tickets_file ||= conf["tickets_file"]
    end

    def self.organizations_file
      @organizations_file
    end

    def self.users_file
      @users_file
    end

    def self.tickets_file
      @tickets_file
    end

  end
end