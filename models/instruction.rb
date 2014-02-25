class Instruction
  attr_reader :action
  attr_reader :start_time

  def initialize(string)
    matches = string.match(/^([a-zA-Z]+?)\s(.*?)$/)
    @action = parse_action(matches[0])
    @start_time = parse_time(matches[1])
  end

  private

  def parse_action(action)
    case action
    when 'book' then :book
    when 'cancel' then :cancel
    else raise InvalidAction
    end
  end

  def parse_time(string)
    Chronic.parse(string)
  end

  class Error < StandardError; end
  class InvalidAction < Error;
end
