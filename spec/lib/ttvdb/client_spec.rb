require 'spec_helper'

describe TTVDB::Client do
  client = TTVDB::Client.new
  it "#get_series should return 'The Adventures of the Galaxy Rangers' EN" do
    series = client.get_series "Galaxy Rangers"
    series.should be_instance_of Array
    series.count.should be >= 1
    series[0].name.should eql "The Adventures of the Galaxy Rangers"
    series[0].language.should eql "en"
    series[0].id.should eql 77772
  end
  it "#get_series_by_id should return 'The Adventures of the Galaxy Rangers' EN" do
    series = client.get_series_by_id 77772
    series.should be_instance_of TTVDB::Series
    series.name.should eql "The Adventures of the Galaxy Rangers"
    series.language.should eql "en"
    series.id.should eql 77772
  end
  it "#get_series should return 'Galaxy Rangers' DE" do
    client.language = 'de'
    series = client.get_series "Galaxy Rangers"
    client.language = 'en'
    series.should be_instance_of Array
    series.count.should be >= 1
    series[0].name.should eql "Galaxy Rangers"
    series[0].language.should eql "de"
    series[0].id.should eql 77772

  end
  it "#get_series_by_id should return 'Galaxy Rangers' DE" do
    client.language = 'de'
    series = client.get_series_by_id 77772
    client.language = 'en'
    series.should be_instance_of TTVDB::Series
    series.name.should eql "Galaxy Rangers"
    series.language.should eql "de"
    series.id.should eql 77772
  end
end
