[![Build Status](https://travis-ci.org/lotherk/ttvdb.png?branch=master)](https://travis-ci.org/lotherk/ttvdb)

# TTVDB

This is another [TheTVDB.com](http://www.thetvdb.com) API library. The others out there didn't fit my needs (if they even worked).

Source code is available at [github](https://github.com/lotherk/ttvdb)

Documentation is available at [rubydoc.info](http://rubydoc.info/github/lotherk/ttvdb)

Gem is available at [rubygems.org](https://rubygems.org/gems/ttvdb)

## Installation

Add this line to your application's Gemfile:

    gem 'ttvdb'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install ttvdb

From source:

    $ git clone https://github.com/lotherk/ttvdb
    $ cd ttvdb
    $ rake build
    $ gem install pkg/ttvdb-VERSION.gem

## Usage

### Using the CLI tools

#### Synopsis
```
ttvdb 0.0.4 (c) 2014 Konrad Lother

usage: ttvdb [global options] <subcommand> [subcommand options]

Available subcommands:
  search           - search a serie

Global options:
  --language, -l <s>:   Language (default: en)
         --debug, -d:   Enable debug messages
       --version, -v:   Print version and exit
          --help, -h:   Show this message
```

#### search

The ```search``` subcommand lets you search for a particular series.

```
Search for a series

usage: ttvdb [options] search [options] name1 name2 name3 ...

nameN can either be id or name

Example:

  $ ttvdb search "Galaxy Rangers"

  $ ttvdb search 77772

  $ ttvdb search "Galaxy Rangers" -d

  $ ttvdb search "Galaxy Rangers" -d -l 10

  $ ttvdb search 77772 -e heartbeat

  $ ttvdb search 77772 -e s01e65

  $ ttvdb search 77772 -e e65

  $ ttvdb search 77772 -e 65

Options:
     --detailed, -d:   show detailed informations for a series
    --limit, -l <i>:   limit result if --detailed is used (default: 0)
  --episode, -e <s>:   show detailed informations for an episode. can be name,
                       name or id
         --help, -h:   Show this message
```

### Writing Code

Require the gem

```ruby
require 'ttvdb'
```

Create a ```TTVDB::Client``` instance

```ruby
client = TTVDB::Client.new(options={})
```

Where ```options``` can be:

| key | value | description
| --- | :---: | --- |
| ```:api_key``` | api key | Your TheTVDB API Key, *optional* |
| ```:api_url``` | http://www.thetvdb.com/api/ | API Url, *optional* |
| ```:language```|```en```,```de```,```fr```,... | The language code to use. Fallback is ```en```, *optional* |

# Example

This is an example script that fetches a series by ARGV. if ARGV is an integer, it will fetch it by its id otherwise by its name. It will then print a little overview about the series.

## Usage
```bash
$ ruby ttvdb_example.rb "Galaxy Rangers"
# or
$ ruby ttvdb_example.rb 77772
```

## Code
```ruby
#!/usr/bin/env ruby
require "ttvdb"

TTVDB.logger.level = Logger::WARN

client = TTVDB::Client.new
series = nil

if ARGV[0].to_i > 0
  series = [client.get_series_by_id(ARGV[0].to_i)]
else
  series = client.get_series ARGV[0]
end

series.each do |serie|
  puts serie.name
  puts "Overview:"
  puts serie.overview

  puts ""
  serie.seasons.each do |season, episodes|
    puts "Season: %02d" % season
    episodes.each do |number, episode|
      puts "  #%02d - %s" % [number, episode.name]
    end
  end
end
```


See the ```examples/``` folder for a complete list of examples. I try to make them as easy to understand as possible.


## Contributing

1. Fork it ( http://github.com/lotherk/ttvdb/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
