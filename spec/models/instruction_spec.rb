require 'spec_helper'

describe Instruction do
  it "parses a book action correctly" do
    instruction = Instruction.new("book tomorrow 8:15am")
    instruction.action.should == :book
    instruction.start_time.strftime("%H:%M").should == "08:15"
  end

  it "parses a cancel action correctly" do
    instruction = Instruction.new("cancel tomorrow 7:15pm")
    instruction.action.should == :cancel
    instruction.start_time.strftime("%H:%M").should == "19:15"
  end

  it "raises an exception if an invalid action is specified" do
    expect {
      Instruction.new("activate tomorrow 7:15pm")
    }.to raise_error Instruction::InvalidAction
  end

  it "raises an exception if the time is unparseable" do
    expect {
      Instruction.new("book at the first full moon")
    }.to raise_error Instruction::TimeParsingFailed
  end
end
