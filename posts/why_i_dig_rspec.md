I've been using RSpec a fair amount lately, so I thought I'd talk about some of its features I really dig.

# The `rspec -f d` command
If `context`s and `describe`s are favored over loaded setup and `it` blocks that do too much, you can get some really nice, verbose output from this command.

For example, suppose I have some specs describing a `#wear_hat?` method of a `SimpleDecisions` class. My `rspec -f d` output might look something like the following:

```
SimpleDecisions
  #wear_hat?
    when I am a vampire
      and its sunny out
        returns true
      and its night time
        returns false
    when I am at a home baseball game
      returns true
    when I am at an away baseball game
      and my hat is for my home team
        returns false
```

Pretty nice, huh? The specs almost match what we would expect the structure of the implementation to be!

# Template specs
There's a lot of debate out there about whether test code should be DRY. Some say it shouldn't and that tests should flow and provide context. Others assert (no pun intended) that tests should be maintainable and, therefore, just a clean (or cleaner) than production code. Template specs meet somewhere in the middle. They can replace many repeated tests at the (slight) expense of maintainability by looping through values and outcomes. For example, a template spec on an absolute value method might look like:

```
describe Math do

  describe '.abs' do
    [
      [42, 42],
      [0, 0],
      [-42, 42]
    ].each do |given_number, expected_number|

      context "given #{given_number}" do
       subject { described_class.abs(given_number) } 

       it { should be(expected_number) }
      end

    end
  end

end
```
In my mind, templates are nice when testing a [pure function]{http://en.wikipedia.org/wiki/Pure_function} or there are multiple, similar tests that can be aggregated.

# [Argument matchers]{https://github.com/rspec/rspec-mocks#argument-matchers}
These are very cool. For example, say I want to test that an error is logged in a certain case, and I don't care about the specific error text, rather I just want the message to be some `String`. I could write something like this:

```
  # ...
  it 'logs an error' do
    ErrorLogger.should_receive(:write).with(kind_of(String))
    # cause error
  end
  # ...
```
This is a fairly trivial example, but these things are powerful. For a further example, presume `ErrorLogger.write` actually takes two parameters but I don't care about the second. The line would then become `ErrorLogger.should_receive(:write).with(kind_of(String), anything)`.

# Natural decoupling
By providing methods like `subject` and `described_class` and providing mechanisms to easily redefine the former, RSpec decouples the specs from things like the name of the class under test or the method being tested. For example, in my above absolute value example, if I changed the class from `Math` to `MathUtils` then, assuming everywhere below I referenced `Math` as `described_class`, I would only have to rename at the top of the file. One change in the production code would merit one change in the tests. Perfect!

# Conclusion
Well, I hope I've expressed some of my favorite things about RSpec. If you would like to see any of my specs, they shouldn't be hard to find in my [ruby repositories on github]{https://github.com/mjgpy3}. If you have any comments on these points, or anything you really like about RSpec (or dislike for that matter) I'd love to hear your comments.
