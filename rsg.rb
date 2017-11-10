# Extracts just the definitions from the grammar file
# Returns an array of strings where each string is the lines for
# a given definition (without the braces)
def read_grammar_defs(filename)
  filename = 'grammars/' + filename unless filename.start_with? 'grammars/'
  filename += '.g' unless filename.end_with? '.g'
  contents = open(filename, 'r') { |f| f.read }
  contents.scan(/\{(.+?)\}/m).map do |rule_array|
    rule_array[0]
  end
end

# Takes data as returned by read_grammar_defs and reformats it
# in the form of an array with the first element being the
# non-terminal and the other elements being the productions for
# that non-terminal.
# Remember that a production can be empty (see third example)
# Example:
#   split_definition "\n<start>\nYou <adj> <name> . ;\nMay <curse> . ;\n"
#     returns ["<start>", "You <adj> <name> .", "May <curse> ."]
#   split_definition "\n<start>\nYou <adj> <name> . ;\n;\n"
#     returns ["<start>", "You <adj> <name> .", ""]
def split_definition(raw_def)
  # Only works for a single string. If needed, this can be amended
  raw_def.map { |str|
    str.tr("\t\n", '').sub('>', '>;').gsub('> ', '>').gsub(' <', '<').split(';')
  }
end


# Takes an array of definitions where the definitions have been
# processed by split_definition and returns a Hash that
# is the grammar where the key values are the non-terminals
# for a rule and the values are arrays of arrays containing
# the productions (each production is a separate sub-array)

# Example:
# to_grammar_hash([["<start>", "The   <object>   <verb>   tonight."], ["<object>", "waves", "big    yellow       flowers", "slugs"], ["<verb>", "sigh <adverb>", "portend like <object>", "die <adverb>"], ["<adverb>", "warily", "grumpily"]])
# returns {"<start>"=>[["The", "<object>", "<verb>", "tonight."]], "<object>"=>[["waves"], ["big", "yellow", "flowers"], ["slugs"]], "<verb>"=>[["sigh", "<adverb>"], ["portend", "like", "<object>"], ["die", "<adverb>"]], "<adverb>"=>[["warily"], ["grumpily"]]}
def to_grammar_hash(split_def_array)
  grammar_hash = Hash.new
  split_def_array.each do |arr|
    new_array = []
    arr.each do |strings|
      new_array.push(strings.gsub('<', ' <').gsub('>', '> ').split).each do|value|
        value.each do |element|
          element.delete(' ')
        end
      end
    end
    grammar_hash[arr[0].downcase] = new_array[1..-1]
  end
  return grammar_hash
end

#print to_grammar_hash([["<start>", "The   <object>   <verb>   tonight."], ["<object>", "waves", "big    yellow       flowers", "slugs"], ["<verb>", "sigh <adverb>", "portend like <object>", "die <adverb>"], ["<adverb>", "warily", "grumpily"]])

# Returns true iff s is a non-terminal
# a.k.a. a string where the first character is <
#        and the last character is >
def is_non_terminal?(s)
  s[0] == '<' and s[-1] == '>'
end

# Given a grammar hash (as returned by to_grammar_hash)
# returns a string that is a randomly generated sentence from
# that grammar
#
# Once the grammar is loaded up, begin with the <start> production and expand it to generate a
# random sentence.
# Note that the algorithm to traverse the data structure and
# return the terminals is extremely recursive.
#
# The grammar will always contain a <start> non-terminal to begin the
# expansion. It will not necessarily be the first definition in the file,
# but it will always be defined eventually. Your code can
# assume that the grammar files are syntactically correct
# (i.e. have a start definition, have the correct  punctuation and format
# as described above, don't have some sort of endless recursive cycle in the
# expansion, etc.). The names of non-terminals should be considered
# case-insensitively, <NOUN> matches <Noun> and <noun>, for example.
def expand(grammar, non_term="<start>")
  # NOT FINISHED!!!!
  final_string = ''
  string_array = grammar[non_term.downcase] # case insensitive because to_grammar_hash only inputs lowercase
  if non_term == '<start>'
    string_array.each do |word|
      word.each do |element|
        if is_non_terminal? element
          final_string += expand(grammar, element)
        else
          if element.count("a-zA-Z0-9").zero?
            final_string += element
          else
            final_string += ' ' + element
          end
        end
      end
    end
  else
    selection = string_array[rand(string_array.length)]
    selection.each do |word|
      if is_non_terminal? word
        final_string += expand(grammar,  word)
      else
        if word[0].count("a-zA-Z0-9").zero?
          final_string += word
        else
          final_string += ' ' + word
        end
      end
    end
  end

  return final_string
end


# Given the name of a grammar file,
# read the grammar file and print a
# random expansion of the grammar
def rsg(filename)

  expand( to_grammar_hash( split_definition( read_grammar_defs(filename))))

end

if __FILE__ == $0
  # prompt the user for the name of a grammar file
  # rsg that file
  puts 'Enter file name: '
  fileName = gets.chomp
  print rsg(fileName)
end