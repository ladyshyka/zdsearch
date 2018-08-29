module ZDSearch
  class SearchResponder

    def self.report(organizations = {}, users = {}, tickets = {})
      organizations_list = parse_organization(organizations) if organizations
      users_list = parse_users(users) if users
      tickets_list = parse_tickets(tickets) if tickets

      SearchResponse.new(organizations_list, users_list, tickets_list)
    end

    def self.parse_organization(organizations_map)
      organizations_map.map{ |orgs| Organization.new(orgs) }
    end

    def self.parse_users(users_map)
      users_map.map do |user|
        u = User.new(user)
        u.organization = look_up_organisation(u.organization_id)
        u
      end
    end

    def self.parse_tickets(tickets_map)
      tickets_map.map do |ticket|
        t = Ticket.new(ticket)
        t.organization = look_up_organisation(t.organization_id)
        t.assignee = look_up_user(t.assignee_id)
        t.submitter = look_up_user(t.submitter_id)
        t
      end
    end

    def self.look_up_organisation(_id)
      @organizations ||= DataStore.organizations_data.map{ |orgs| Organization.new(orgs) }

      @organizations.find{|org| org._id == _id }
    end

    def self.look_up_user(_id)
      @users ||= DataStore.users_data.map do |user|
        u = User.new(user)
        u.organization = look_up_organisation(u.organization_id)
        u
      end

      @users.find{|user| user._id == _id }
    end

    private_class_method :look_up_organisation
    private_class_method :look_up_user
  end

  class SearchResponse
    attr_reader :organizations, :users, :tickets

    def initialize(organizations, users, tickets)
      @organizations = organizations || []
      @users = users || []
      @tickets = tickets || []
    end

    def prettify_str
      results = ""

      results << "#{@organizations.count} Organization#{@organizations.count > 1 ? 's':''} Found\n"

      @organizations.each do |organization|
        results << organization.prettify_str
        results << "\n"
      end

      results << "#{@users.count} User#{@users.count > 1 ? 's':''} Found\n"
      # TODO Column Names
      @users.each do |user|
        results << user.prettify_str
        results << "\n"
      end

      results << "#{@tickets.count} Ticket#{@tickets.count > 1 ? 's':''} Found\n"
      # TODO Column Names
      @tickets.each do |ticket|
        results << ticket.prettify_str
        results << "\n"
      end

      if (@organizations.count > 0 || @users.count > 0 || @tickets.count > 0)
        results << "-----------\n"
        results << "#{@organizations.count} Organization#{@organizations.count > 1 ? 's':''} Found\n"
        results << "#{@users.count} User#{@users.count > 1 ? 's':''} Found\n"
        results << "#{@tickets.count} Ticket#{@tickets.count > 1 ? 's':''} Found\n"
      end

      results
    end
  end

  class Organization
    attr_accessor :_id, :url, :external_id, :name,
                  :domain_names, :created_at, :details,
                  :shared_tickets, :tags

    def initialize(attributes = {})
      attributes.each do |name, value|
        send("#{name}=", value) if respond_to?(name)
      end
    end

    def prettify_str
      info = "#{@name ? @name.upcase : 'NO NAME'}\n"
      info << "id: #{@_id}\n"
      info << "url: #{@url}\n"
      info << "External id: #{@external_id}\n"
      info << "Domain names: #{@domain_names}\n"
      info << "Created at: #{@created_at}\n"
      info << "Details: #{@details}\n"
      info << "Shared Tickets: #{@shared_tickets}\n"
      info << "Tags: #{@tags}\n"
    end
  end

  class User
    attr_accessor :_id, :url, :external_id, :name,
                  :alias, :created_at, :active,
                  :verified, :shared, :locale, :timezone,
                  :last_login_at, :email, :phone, :signature,
                  :organization_id, :organization, :tags, :suspended,
                  :role

    def initialize(attributes = {})
      attributes.each do |name, value|
        send("#{name}=", value) if respond_to?(name)
      end
    end

    def prettify_str
      info = "#{@name ? @name.upcase : 'NO NAME'}\n"
      info << "Id: #{@_id}\n"
      info << "Url: #{@url}\n"
      info << "External Id: #{@external_id}\n"
      info << "Alias: #{@alias}\n"
      info << "Created at: #{@created_at}\n"
      info << "Active: #{@active}\n"
      info << "Verified: #{@verified}\n"
      info << "Shared: #{@shared}\n"
      info << "Locale: #{@locale}\n"
      info << "Timezone: #{@timezone}\n"
      info << "Last login at: #{@last_login_at}\n"
      info << "Email: #{@email}\n"
      info << "Phone: #{@phone}\n"
      info << "Signature: #{@signature}\n"
      info << "Organization: #{@organization.name}\n" if @organization
      info << "Organization: #{@organization_id} not found\n" if @organization.nil?
      info << "Tags: #{@tags}\n"
      info << "Suspended: #{@suspended}\n"
      info << "Role: #{@role}\n"
    end
  end

  class Ticket
    attr_accessor :_id, :url, :external_id, :created_at,
                  :type, :subject, :description, :priority,
                  :status, :submitter_id, :submitter, :assignee_id,
                  :assignee, :organization_id, :organization, :tags,
                  :has_incidents, :due_at, :via

    def initialize(attributes = {})
      attributes.each do |name, value|
        send("#{name}=", value) if respond_to?(name)
      end
    end

    def prettify_str
      info = "#{@subject ? @subject.upcase : 'NO SUBJECT'}\n"
      info << "Id: #{@_id}\n"
      info << "Url: #{@url}\n"
      info << "External_id: #{@external_id}\n"
      info << "Created_at: #{@created_at}\n"
      info << "Type: #{@type}\n"
      info << "Description: #{@description}\n"
      info << "Priority: #{@priority}\n"
      info << "Status: #{@status}\n"
      info << "Submitter: #{@submitter.name}\n" if @submitter
      info << "Submitter: #{@submitter_id} not found\n" if @submitter.nil?
      info << "Assignee: {@assignee.name}\n" if @assignee
      info << "Assignee: #{@assignee_id} not found\n" if @assignee.nil?
      info << "Organization: #{@organization.name}\n" if @organization
      info << "Organization: #{@organization_id} not found \n" if @organization.nil?
      info << "Tags: #{@tags}\n"
      info << "Has incidents? #{@has_incidents}\n"
      info << "Due at: #{@due_at}\n"
      info << "Via: #{@via}\n"
    end
  end
end