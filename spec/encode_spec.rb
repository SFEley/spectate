require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe Spectate::Encode do
  include Spectate::Encode
  describe "encoding" do
    it "changes spaces to underscores" do
      encode("I am the very model of a modern Major General").should == "I_am_the_very_model_of_a_modern_Major_General"
    end
    
    it "changes underscores to double underscores" do
      encode("snake_case is too_cool").should == "snake__case_is_too__cool"
    end
    
    it "CGI-encodes everything else" do
      encode("2 + 1 is equal_to 5 & that's a fact!").should == "2_%2B_1_is_equal__to_5_%26_that%27s_a_fact%21"
    end
  end

  describe "decoding" do
    it "changes underscores to spaces" do
      decode("I_am_the_very_model_of_a_modern_Major_General").should == "I am the very model of a modern Major General"
    end
    
    it "changes double underscores to spaces" do
      decode("snake__case_is_too__cool").should == "snake_case is too_cool" 
    end
    
    it "CGI-encodes everything else" do
      decode("2_%2B_1_is_equal__to_5_%26_that%27s_a_fact%21").should == "2 + 1 is equal_to 5 & that's a fact!"
    end
  end
end