# TTVDB

This is another [TheTVDB.com](http://www.thetvdb.com) API library. The others out there didn't fit my needs (if they even worked).


## Installation

Add this line to your application's Gemfile:

    gem 'ttvdb'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install ttvdb

## Usage

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

This is an example script that fetches a series by ARGV. if ARGV is an integer, it ill fetch it by its id otherwise by its name. It will then print a little overview about the series.

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

1. Fork it ( http://github.com/<my-github-username>/ttvdb/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
