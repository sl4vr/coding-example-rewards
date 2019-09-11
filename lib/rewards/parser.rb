# frozen_string_literal: true

module Rewards
  # Parses action log and creates actions
  class Parser
    ParseError = Class.new(StandardError)
    UnknownActionError = Class.new(ParseError)
    DateTimeParseError = Class.new(ParseError)

    def initialize(log)
      @log = log
    end

    def parse
      actions = @log.split("\n").map { |line| parse_line(line) }
      actions.compact
    end

    private

    def parse_line(line)
      date, time, object, type, subject = line.split(' ')
      datetime = parse_datetime(date, time)

      case type
      when 'recommends'
        Params::Recommend.new(
          created_at: datetime,
          customer_name: object,
          recommended_name: subject
        )
      when 'accepts'
        Params::Accept.new(
          created_at: datetime,
          customer_name: object
        )
      else
        raise UnknownActionError, "Unknown action: '#{type}'"
      end
    rescue ParseError => error
      puts error.message
    end

    def parse_datetime(date, time)
      DateTime.parse("#{date} #{time}")
    rescue ArgumentError => error
      raise DateTimeParseError, error.message
    end
  end
end
