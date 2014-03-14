require 'spec_helper'

describe TTVDB::Series do
  describe "#initialize" do
    let(:serie) {
      data = XmlSimple.xml_in(File.read("./spec/res/series_all_en.xml"))
      TTVDB::Series.new(data["Series"][0])
    }

    context "id" do
      it { serie.id.should eql 77772 }
    end

    context "actors" do
      it { serie.actors.should include("Bob Bottone") }
    end

    context "first_aired" do
      it { serie.first_aired.should eql Time.parse("1986-09-01") }
    end

    context "genre" do
      it { serie.genre.should include("Animation") }
    end

    context "imdb_id" do
      it { serie.imdb_id.should eql "tt0090436" }
    end

    context "language" do
      it { serie.language.should eql "en" }
    end

    context "overview" do
      it { serie.overview.should include("Welcome to The Adventures of the Galaxy Rangers") }
    end

    context "rating" do
      it { serie.rating.should eql 8.0 }
    end

    context "rating_count" do
      it { serie.rating_count.should eql 4 }
    end

    context "runtime" do
      it { serie.runtime.should eql 30 }
    end

    context "series_id" do
      it { serie.series_id.should eql 6914 }
    end

    context "name" do
      it { serie.name.should eql "The Adventures of the Galaxy Rangers" }
    end

    context "status" do
      it { serie.status.should eql "Ended" }
    end

    context "banner" do
      it { serie.banner.should eql "graphical/77772-g2.jpg" }
    end

    context "fanart" do
      it { serie.fanart.should eql "fanart/original/77772-1.jpg" }
    end

    context "last_updated" do
      it { serie.last_updated.should eql Time.at(1394491306) }
    end

    context "poster" do
      it { serie.poster.should eql "posters/77772-3.jpg" }
    end
  end
end
