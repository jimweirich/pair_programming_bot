module States

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

end
