require 'spec_helper'

describe TTVDB do
  it "#logger" do
#      TTVDB.logger.should be_instance_of Logger
      expect(TTVDB.logger.class).to equal(Logger)
  end
end
