class PPBotViewController < UIViewController
  attr_accessor :state

  def viewDidLoad
    create_title

    top = 200

    @q1 = UILabel.new
    @q1.font = UIFont.systemFontOfSize(20)
    @q1.text = '(initial)'
    @q1.textAlignment = UITextAlignmentCenter
    @q1.textColor = UIColor.whiteColor
    @q1.backgroundColor = UIColor.clearColor
    @q1.frame = [[margin, top+30], [view.frame.size.width - margin * 2, 40]]
    view.addSubview(@q1)

    @q2 = UILabel.new
    @q2.font = UIFont.systemFontOfSize(20)
    @q2.text = '(initial)'
    @q2.textAlignment = UITextAlignmentCenter
    @q2.textColor = UIColor.whiteColor
    @q2.backgroundColor = UIColor.clearColor
    @q2.frame = [[margin, top+60], [view.frame.size.width - margin * 2, 40]]
    view.addSubview(@q2)

    @yes_button = UIButton.buttonWithType(UIButtonTypeRoundedRect)
    @yes_button.setTitle('(A)', forState:UIControlStateNormal)
    @yes_button.setTitle('(A)', forState:UIControlStateSelected)
    @yes_button.addTarget(self, action:'yesTapped', forControlEvents:UIControlEventTouchUpInside)
    @yes_button.frame = [[margin, top+2*60], [view.frame.size.width - margin * 2, 40]]
    view.addSubview(@yes_button)

    @no_button = UIButton.buttonWithType(UIButtonTypeRoundedRect)
    @no_button.setTitle('(B)', forState:UIControlStateNormal)
    @no_button.setTitle('(B)', forState:UIControlStateSelected)
    @no_button.addTarget(self, action:'noTapped', forControlEvents:UIControlEventTouchUpInside)
    @no_button.frame = [[margin, top+3*60], [view.frame.size.width - margin * 2, 40]]
    view.addSubview(@no_button)

    @state = HaveTestState.instance
    @state.establish(self)
  end

  def yesTapped
    @state.yes(self)
    @state.establish(self)
  end

  def noTapped
    @state.no(self)
    @state.establish(self)
  end

  def ask(question)
    set_text(question)
    @yes_button.setTitle("Yes", forState:UIControlStateNormal)
    @yes_button.setTitleColor(green, forState: UIControlStateNormal)
    @no_button.setTitle("No", forState:UIControlStateNormal)
    @no_button.setTitleColor(red, forState: UIControlStateNormal)
    @no_button.hidden = false
  end

  def doit(action, more_action=nil)
    set_text(action, more_action)
    @yes_button.setTitle("Done", forState:UIControlStateNormal)
    @yes_button.setTitleColor(blue, forState: UIControlStateNormal)
    @no_button.setTitle("", forState:UIControlStateNormal)
    @no_button.hidden = true
  end

  def set_text(text1, text2=nil)
    if text2
      @q1.hidden = false
      @q1.text = text1
      @q2.text = text2
    else
      @q1.hidden = true
      @q1.text = ""
      @q2.text = text1
    end
  end

  def margin
    @margin ||= 30
  end

  def blue
    @blue ||= UIColor.colorWithRed(0.10, green: 0.10, blue: 0.70, alpha: 1.0)
  end

  def red
    @red ||= UIColor.colorWithRed(0.60, green: 0.10, blue: 0.10, alpha: 1.0)
  end

  def green
    @green ||= UIColor.colorWithRed(0.10, green: 0.60, blue: 0.10, alpha: 1.0)
  end

  class ProgrammingState
    def self.instance
      @instance ||= new
    end
  end

  class HaveTestState < ProgrammingState
    def establish(target)
      target.ask("Do you have a test for that?")
    end
    def yes(target)
      target.state = TestPassState.instance
    end
    def no(target)
      target.state = WriteTestState.instance
    end
  end

  class WriteTestState < ProgrammingState
    def establish(target)
      target.doit("Write a test.")
    end
    def yes(target)
      target.state = TestPassState.instance
    end
    def no(target)
    end
  end

  class TestPassState < ProgrammingState
    def establish(target)
      target.ask("Does the test pass?")
    end
    def yes(target)
      target.state = NeedToRefactorState.instance
    end
    def no(target)
      target.state = WriteCodeState.instance
    end
  end

  class WriteCodeState < ProgrammingState
    def establish(target)
      target.doit("Write just enough code", "for the test to pass.")
    end
    def yes(target)
      target.state = TestPassState.instance
    end
    def no(target)
    end
  end

  class NeedToRefactorState < ProgrammingState
    def establish(target)
      target.ask("Do you need to refactor?")
    end
    def yes(target)
      target.state = RefactorState.instance
    end
    def no(target)
      target.state = SelectFeatureState.instance
    end
  end

  class SelectFeatureState < ProgrammingState
    def establish(target)
      target.doit("Select a feature", "to implement.")
    end
    def yes(target)
      target.state = HaveTestState.instance
    end
    def no(target)
    end
  end

  class RefactorState < ProgrammingState
    def establish(target)
      target.doit("Refactor the code.")
    end
    def yes(target)
      target.state = TestPassState.instance
    end
    def no(target)
    end
  end

  private

  def create_title
    @title_y = 30
    @title1 = create_title_label("Pair")
    @title2 = create_title_label("Programming")
    @title3 = create_title_label("Bot")
  end

  def create_title_label(text)
    label = UILabel.new
    label.font = UIFont.systemFontOfSize(30)
    label.text = text
    label.textAlignment = UITextAlignmentCenter
    label.textColor = UIColor.whiteColor
    label.backgroundColor = UIColor.clearColor
    label.frame = [[margin, @title_y], [view.frame.size.width - margin * 2, 40]]
    view.addSubview(label)
    @title_y += 40
    label
  end
end
