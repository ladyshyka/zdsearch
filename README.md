# ZDSearch

This is a very simple CLI for conducting searches on
* Tickets
* Users and
* Organisations

## Dependencies
ZDSearch requires Ruby to run

Install [Homebrew](https://brew.sh/)

Install [Ruby](https://www.ruby-lang.org/en/documentation/installation/)

	$ brew install ruby

Install [Bundler](http://bundler.io/)

	$ gem install bundler

## Installation

Clone ZDSearch Git repository

	$ git clone git@github.com:ladyshyka/zdsearch.git

Install zdsearch locally

	$ bundle exec rake install
	
Run the tests
	
	$ bundle exec rake spec
	
OR

	$ bundle exec rspec		

## Usage

### Run the help command
	$ bundle exec zdsearch -h
	
```
Usage: zdsearch [OPTIONS]
Options
    -c, --config YAML                The config YAML file location
    -k, --keyword KEYWORD            The keyword to search by
    -f, --field FIELD                The field to search by
    -t, --type TYPE                  The type of items to search by; [organizations, users, tickets]
    -h, --help                       Lists these options
You must supply a --config to define the JSON data source locations
```

### Configure your source files
Zdsearch takes in a configuration file which assumes 3 variables.
These variables are expected to provide the path to the organizations, tickets and users JSON files.
```yaml
organizations_file: <PATH>/organizations.json
tickets_file: <PATH>/tickets.json
users_file: <PATH>/users.json
```

### Conduct a Keyword Search
	
	$ zdsearch -c conf -k <keyword>
	
### Search for Organisation

	$ zdsearch -c conf -t "organizations" -k <keyword>

### Search for User

	$ zdsearch -c conf -t "users" -k <keyword>

### Search for Ticket

	$ zdsearch -c conf -t "tickets" -k <keyword>
	
### Search for a Specific Field

	$ zdsearch -c conf -k <keyword> -f <field_name>
	
### Search for an Empty Field
By searching for a field without a keyword, you're telling zdsearch to find all 
occurrences where the field is empty.
Note: The field still needs to exist in the JSON file.

	$ zdsearch -c conf -f <field_name>		

## Development

After checking out the repo, run `gem install bundler`, 
and then run `bin/setup` to install dependencies. 
Then, run `bundle exec rspec` to run the tests. 
You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. 

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/ladyshyka/zdsearch.

