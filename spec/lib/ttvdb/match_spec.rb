require 'spec_helper'

describe TTVDB::Match do
  let(:serie) { @serie ||= TTVDB::Client.new.get_series_by_id 77772 }
  describe "#match" do
    context "simple" do
      let(:filename) { "s01e65.avi" }
      it { serie.match_episode(filename).name.should eql "Heartbeat" }
    end

    context "sorted" do
      let(:filename) { "gr65.avi" }
      it { serie.match_episode(filename, :filter => :sorted).name.should eql "Heartbeat" }
    end

    context "name" do
      let(:filename) { "Galaxy.Rangers.-.Heartbeat.avi" }
      it { serie.match_episode(filename, :filter => :name, :min => 46)[1].name.should eql "Heartbeat" }
    end
  end
end
