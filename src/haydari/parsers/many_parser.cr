require "../parser"

class Haydari::ManyParser(T) < Haydari::Parser(Array(T))
    def initialize(@parser : Parser(T), @at_least = 0, @limit = Int32::MAX)
        if @parser.is_a?(ManyParser)
            raise "Using many parser inside a many parser is not allowed!"
        end

        @output = [] of T
    end

    def parse(input)
        while @parser.run(input) && @output.size < @limit
            @output << @parser.output.not_nil! as T
            @parser.reset
        end

        @output.size >= @at_least
    end

    def reset
        @output = [] of T
        @parser.reset
    end
end
