describe States do
  Given(:cont) { "hi" }
  Given!(:x) { 10 }

  When(:result) { "#{cont}#{x}" }
  When { @other = 12 }

  context "one" do
    Given(:x) { 20 }
    Then { x.should == 20 }
  end

  Then {
    cont.should == "hi"
    x.should == 10
    result.should == "hi10"
    @other.should == 12
  }
end
