describe "Application 'pairprogrammingbot'" do
  before do
    @app = UIApplication.sharedApplication
  end

  it "has one window" do
    @app.windows.size.should == 1
  end
end

describe PPBotViewController do
  before do
    @controller = PPBotViewController.alloc.init
  end

  it "has a controller" do
    @controller.should != nil
  end
end
