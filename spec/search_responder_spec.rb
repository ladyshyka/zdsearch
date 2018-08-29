RSpec.describe ZDSearch::SearchResponder do

  context 'SearchResponder' do
    let(:organization) {
      {
        "_id": 119,
        "url": "http://initech.zendesk.com/api/v2/organizations/119.json",
        "external_id": "2386db7c-5056-49c9-8dc4-46775e464cb7",
        "name": "Multron",
        "domain_names": [
                 "bleeko.com",
                 "pulze.com",
                 "xoggle.com",
                 "sultraxin.com"
               ],
        "created_at": "2016-02-29T03:45:12 -11:00",
        "details": "Non profit",
        "shared_tickets": false,
        "tags": [
                 "Erickson",
                 "Mccoy",
                 "Wiggins",
                 "Brooks"
               ]
      }
    }
    let(:user) {
      {
        "_id": 1,
        "url": "http://initech.zendesk.com/api/v2/users/1.json",
        "external_id": "74341f74-9c79-49d5-9611-87ef9b6eb75f",
        "name": "Francisca Rasmussen",
        "alias": "Miss Coffey",
        "created_at": "2016-04-15T05:19:46 -10:00",
        "active": true,
        "verified": true,
        "shared": false,
        "locale": "en-AU",
        "timezone": "Sri Lanka",
        "last_login_at": "2013-08-04T01:03:27 -10:00",
        "email": "coffeyrasmussen@flotonic.com",
        "phone": "8335-422-718",
        "signature": "Don't Worry Be Happy!",
        "organization_id": 119,
        "tags": [
                 "Springville",
                 "Sutton",
                 "Hartsville/Hartley",
                 "Diaperville"
               ],
        "suspended": true,
        "role": "admin"
      }
    }
    let(:ticket) {
      {
        "_id": "50dfc8bc-31de-411e-92bf-a6d6b9dfa490",
        "url": "http://initech.zendesk.com/api/v2/tickets/50dfc8bc-31de-411e-92bf-a6d6b9dfa490.json",
        "external_id": "8bc8bee7-2d98-4b69-b4a9-4f348ff41fa3",
        "created_at": "2016-03-08T09:44:54 -11:00",
        "type": "task",
        "subject": "A Problem in South Africa",
        "description": "Esse nisi occaecat pariatur veniam culpa dolore anim elit aliquip. Cupidatat mollit nulla consectetur ullamco tempor esse.",
        "priority": "high",
        "status": "hold",
        "submitter_id": 1,
        "assignee_id": 1,
        "organization_id": 119,
        "tags": [
                 "Georgia",
                 "Tennessee",
                 "Mississippi",
                 "Marshall Islands"
               ],
        "has_incidents": true,
        "due_at": "2016-08-03T09:17:37 -10:00",
        "via": "voice"
      }
    }

    before do
      allow(ZDSearch::DataStore).to receive(:organizations_data).and_return([organization])
      allow(ZDSearch::DataStore).to receive(:users_data).and_return([user])
      allow(ZDSearch::DataStore).to receive(:tickets_data).and_return([ticket])
    end

    describe '#report' do

      let(:organizations) { nil }
      let(:users) { nil }
      let(:tickets) { nil }

      subject { described_class.report(organizations, users, tickets) }

      it 'creates a SearchResponse' do
        expect(subject).to be_kind_of(ZDSearch::SearchResponse)
      end

      context '#parse_organization' do

        let(:organizations) { [organization] }

        subject { described_class.parse_organization(organizations) }

        it 'turns the organization JSON into an array' do
          expect(subject.count).to eq 1
        end

        it 'turns the JSON into Organization objects' do
          expect(subject.first).to be_kind_of(ZDSearch::Organization)
        end

        it 'turns the JSON into Organization objects' do
          expect(subject.first._id).to eq 119
        end

      end

      context '#parse_users' do

        let(:users) { [user] }

        subject { described_class.parse_users(users) }

        it 'turns the users JSON into an array' do
          expect(subject.count).to eq 1
        end

        it 'turns the JSON into User objects' do
          expect(subject.first).to be_kind_of(ZDSearch::User)
        end

        it 'turns the JSON into populated User objects' do
          expect(subject.first._id).to eq 1
        end

        it 'links the User objects with their associated Organizations' do
          expect(subject.first.organization._id).to eq 119
        end

      end

      context '#parse_tickets' do

        let(:tickets) { [ticket] }

        subject { described_class.parse_tickets(tickets) }

        it 'turns the tickets JSON into an array' do
          expect(subject.count).to eq 1
        end

        it 'turns the JSON into Ticket objects' do
          expect(subject.first).to be_kind_of(ZDSearch::Ticket)
        end

        it 'turns the JSON into populated Ticket objects' do
          expect(subject.first._id).to eq '50dfc8bc-31de-411e-92bf-a6d6b9dfa490'
        end

        it 'links the Ticket objects with their associated organizations' do
          expect(subject.first.organization._id).to eq 119
        end

        it 'links the User objects with their associated users' do
          expect(subject.first.assignee._id).to eq 1
        end

      end

    end

    describe '#SearchResponse' do
      let(:organization_list) { [instance_double('Organization', prettify_str: 'pretty org')] }
      let(:user_list) { [instance_double('User', prettify_str: 'pretty user'), instance_double('User', prettify_str: 'pretty user')] }
      let(:ticket_list) { [instance_double('Ticket', prettify_str: 'pretty ticket')] }
      let(:response) { ZDSearch::SearchResponse.new(organization_list, user_list, ticket_list) }

      subject { response.prettify_str }

      it 'reports the number of organizations found' do
        expect(subject).to include('1 Organization')
      end

      it 'reports the number of users found' do
        expect(subject).to include('2 Users')
      end

      it 'reports the number of tickets found' do
        expect(subject).to include('1 Ticket')
      end

      it 'outputs the organizations found' do
        expect(subject).to include('pretty org')
      end

      it 'outputs the users found' do
        expect(subject).to include('pretty user')
      end

      it 'outputs the tickets found' do
        expect(subject).to include('pretty ticket')
      end
    end
  end

end