#!/usr/bin/env ruby
# ruby '2.6.2'

# Solution for number to possible words or combinations of words from the provided dictionary,
# that can be mapped back as a whole to the number.

#  Analysis
# Provided :
# Given 10 digits number excluding 0 & 1
# Text file with bunch of wordlist
# phone number mapping to letters
# 2 = a b c
# 3 = d e f
# 4 = g h i
# 5 = j k l
# 6 = m n o
# 7 = p q r s
# 8 = t u v
# 9 = w x y z
# The phone numbers will never contain a 0 or 1.
# Words have to be at least 3 characters.

# Solution
# => Since a words have to be at least 3 characters possible combinations are
# => 3+7, 4+6, 5+5, 6+4, 7+3, 3+3+4, 3+4+3, 4+3+3, 10
# => Beak down the phone number in respective combinations &
# => build a possible words from break down numbers
# => compare with the wordlist

# Assuming the phone_number : 6686787825

# Using pry for debugging
require 'pry'
# To measure performance of code
require 'benchmark'
# For unit test
require "rspec/autorun"

class  NumberConversion
  attr_reader :phone_number, :wordlist

  def initialize(phone_number)
    @phone_number = phone_number.to_s  # Assuming number is in interger form
    @wordlist = {} # Let's store evey wordlist
    # Mapping number to letters
    @number_to_letters_hash_mapping = { '2' => %w[a b c], '3' => %w[d e f], '4' => %w[g h i], '5' => %w[j k l], '6' => %w[m n o], '7' => %w[p q r s], '8' => %w[t u v], '9' => %w[w x y z] }
    # To store relevant words
    @relevant_words = []
  end

  def possible_word_combinations
    # Let's do some validation before proceeding
    return "Invalid Input" if not_valid_number?
    # Read wordlist file
    read_wordlist_file
    matching_words 
  end

  def not_valid_number?
    # Let's check for 
    # => Nil phone umber
    # => Phone number length
    # => Phone number contain 0 or 1
    # => Phone number only contain digits
    phone_number.nil? || !phone_number.length.eql?(10) || (phone_number.split('') & ['0','1']).any? || phone_number.scan(/\D/).any?
  end

  def matching_words
    # Mapping phone number with respective letters
    # mapping_phone_number = [["m", "n", "o"], ["m", "n", "o"], ["t", "u", "v"], ["m", "n", "o"], ["p", "q", "r", "s"], ["t", "u", "v"], ["p", "q", "r", "s"], ["t", "u", "v"], ["a", "b", "c"], ["j", "k", "l"]]
    @mapping_phone_number = phone_number.chars.map { |char| @number_to_letters_hash_mapping[char] }

    # For 3+7, 4+6, 5+5, 6+4, 7+3 combination
    breaking_into_two_part

    # For 3+3+4, 3+4+3, 4+3+3 combination
    breaking_into_three_part

    # For size of 10
    @relevant_words << (@mapping_phone_number.shift.product(*@mapping_phone_number).map(&:join) & @wordlist[10])
    return @relevant_words
  end

  def breaking_into_two_part
    # let's break mapping_phone_number into
    # 3+7, 4+6, 5+5, 6+4, 7+3
    # Since word must be at least 3 character, [0..2]
    phone_number_length = phone_number.length
    i = 2
    while i < (phone_number_length - 3)
      breakdown_phone_number1 = @mapping_phone_number[0..i]
      breakdown_phone_number2 = @mapping_phone_number[(i + 1)..(phone_number_length - 1)]

      # pass this array to compare with wordlist
      matched_words_from_wordlist([breakdown_phone_number1, breakdown_phone_number2])
      i += 1
    end
  end

  def breaking_into_three_part
    # Combination of [3,3,4]
    matched_words_from_wordlist([@mapping_phone_number[0..2], @mapping_phone_number[3..5], @mapping_phone_number[6..9]])

    # Combination of [3,4,3]
    matched_words_from_wordlist([@mapping_phone_number[0..2], @mapping_phone_number[3..6], @mapping_phone_number[7..9]])

    # Combination of [4,3,3]
    matched_words_from_wordlist([@mapping_phone_number[0..3], @mapping_phone_number[4..6], @mapping_phone_number[7..9]])
  end

  def matched_words_from_wordlist(breakdown_phone_number)
    matched_words = []
    breakdown_phone_number.each do |combine_characters|
      # combine characters to produce combine words
      # Combine words of [["m", "n", "o"], ["m", "n", "o"], ["t", "u", "v"]]
      # to produce every possible words
      # ["mmt", "mmu", "mmv", "mnt", "mnu", "mnv", "mot", "mou", "mov", "nmt", "nmu", "nmv", "nnt", "nnu", "nnv", "not", "nou", "nov", "omt", "omu", "omv", "ont", "onu", "onv", "oot", "oou", "oov"]
      char_length = combine_characters.length
      combine_words = combine_characters.shift.product(*combine_characters).map(&:join)
      # Intersection of combine words with @wordlist
      matched_words << (combine_words & @wordlist[char_length])
    end

    # Check for relevant matched_words
    return if matched_words.any?(&:empty?)

    # Making combinations from above output
    # Relevant combination from the list of matched_words
    # Append every possible combination of words in @relevant_words
    # Combination of (3+7, 4+6, 5+5, 6+4, 7+3, 3+3+4, 3+4+3, 4+3+3)
    if matched_words.size == 2
      @relevant_words += matched_words[0].product(matched_words[1])
    elsif matched_words.size == 3
      @relevant_words += matched_words[0].product(matched_words[1]).product(matched_words[2]).map(&:flatten)
    end

  end

  def read_wordlist_file
    # Categories each word according to their length
    # and store in form of hash
    # since number is mapped in lowercase let's convert all wordlist to lowercase(let's skip this later)
    # wordlist = { 2=>["aa", "ab"....], 3=>["aah", "aal"...], ... }

    File.foreach("dictionary.txt") do |word|
      word = word.chop.downcase
      @wordlist[word.length] = @wordlist[word.length].nil? ? [word] : @wordlist[word.length].push(word)
    end
  end

end

# Let's the method call from here
print "Input 10 digits phone number without 0 & 1 : "
phone_number = gets.chomp
puts Benchmark.measure {
  print NumberConversion.new(phone_number).possible_word_combinations
}


# Not good at testing still let's give it a try
describe NumberConversion do
  phone_number1 = 6686787825
  output1 = [["noun", "struck"], ["onto", "struck"], ["motor", "truck"], ["motor", "usual"], ["nouns", "truck"], ["nouns", "usual"], ["mot", "opt", "puck"], ["mot", "opt", "ruck"], ["mot", "opt", "suck"], ["mot", "ort", "puck"], ["mot", "ort", "ruck"], ["mot", "ort", "suck"], ["not", "opt", "puck"], ["not", "opt", "ruck"], ["not", "opt", "suck"], ["not", "ort", "puck"], ["not", "ort", "ruck"], ["not", "ort", "suck"], ["oot", "opt", "puck"], ["oot", "opt", "ruck"], ["oot", "opt", "suck"], ["oot", "ort", "puck"], ["oot", "ort", "ruck"], ["oot", "ort", "suck"], ["mot", "opts", "taj"], ["mot", "opus", "taj"], ["mot", "orts", "taj"], ["not", "opts", "taj"], ["not", "opus", "taj"], ["not", "orts", "taj"], ["oot", "opts", "taj"], ["oot", "opus", "taj"], ["oot", "orts", "taj"], ["noun", "pup", "taj"], ["noun", "pur", "taj"], ["noun", "pus", "taj"], ["noun", "sup", "taj"], ["noun", "suq", "taj"], ["onto", "pup", "taj"], ["onto", "pur", "taj"], ["onto", "pus", "taj"], ["onto", "sup", "taj"], ["onto", "suq", "taj"], ["motortruck"]]
  
  phone_number2 = 2282668687
  output2 = [["act", "amounts"], ["act", "contour"], ["bat", "amounts"], ["bat", "contour"], ["cat", "amounts"], ["cat", "contour"], ["acta", "mounts"], ["act", "boo", "tots"], ["act", "boo", "tour"], ["act", "con", "tots"], ["act", "con", "tour"], ["act", "coo", "tots"], ["act", "coo", "tour"], ["bat", "boo", "tots"], ["bat", "boo", "tour"], ["bat", "con", "tots"], ["bat", "con", "tour"], ["bat", "coo", "tots"], ["bat", "coo", "tour"], ["cat", "boo", "tots"], ["cat", "boo", "tour"], ["cat", "con", "tots"], ["cat", "con", "tour"], ["cat", "coo", "tots"], ["cat", "coo", "tour"], ["act", "boot", "mus"], ["act", "boot", "nus"], ["act", "boot", "our"], ["act", "coot", "mus"], ["act", "coot", "nus"], ["act", "coot", "our"], ["bat", "boot", "mus"], ["bat", "boot", "nus"], ["bat", "boot", "our"], ["bat", "coot", "mus"], ["bat", "coot", "nus"], ["bat", "coot", "our"], ["cat", "boot", "mus"], ["cat", "boot", "nus"], ["cat", "boot", "our"], ["cat", "coot", "mus"], ["cat", "coot", "nus"], ["cat", "coot", "our"], ["acta", "mot", "mus"], ["acta", "mot", "nus"], ["acta", "mot", "our"], ["acta", "not", "mus"], ["acta", "not", "nus"], ["acta", "not", "our"], ["acta", "oot", "mus"], ["acta", "oot", "nus"], ["acta", "oot", "our"], ["catamounts"]]
  context "Number to possible words conversion" do
    it 'Check if phone number is valid' do
      object = NumberConversion.new(phone_number1)
      expect(object.not_valid_number?).to be(false)
    end

    it "Test combination of phone number with multiple words" do
      expect(NumberConversion.new(phone_number1).possible_word_combinations).to  match_array(output1)
    end
  end

  context "Number to possible words conversion" do
    it 'Check if phone number is valid' do
      object = NumberConversion.new(phone_number1)
      expect(object.not_valid_number?).to be(false)
    end

    it "Test combination of phone number with multiple words" do
      expect(NumberConversion.new(phone_number2).possible_word_combinations).to  match_array(output2)
    end
  end
end