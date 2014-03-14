require 'spec_helper'

describe TTVDB::Episode do
  describe "#initialize" do
    let(:episode) {
      data = XmlSimple.xml_in(File.read("./spec/res/episode_5_en.xml"))
      TTVDB::Episode.new(data["Episode"][0])
    }

    context "id" do
      it { episode.id.should eql 258116 }
    end

    context "combined_episodenumber" do
      it { episode.combined_episodenumber.should eql 4.0 }
    end

    context "combined_season" do
      it { episode.combined_season.should eql 1 }
    end

    context "dvd_episodenumber" do
      it { episode.dvd_episodenumber.should eql 4.0 }
    end

    context "name" do
      it { episode.name.should eql "Chained" }
    end

    context "overview" do
      it { episode.overview.should include("Goose is assigned to transport MaCross") }
    end

    context "rating" do
      it { episode.rating.should eql 7.0 }
    end

    context "season_numer" do
      it { episode.season_number.should eql 1 }
    end

    context "last_updated" do
      it { episode.last_updated.should eql Time.at(1393948321) }
    end

    context "season_id" do
      it { episode.season_id.should eql 13571 }
    end

    context "series_id" do
      it { episode.series_id.should eql 77772 }
    end
  end
end
