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


class  NumberConversion
  attr_reader :phone_number, :wordlist

  def initialize(phone_number)
    @phone_number = phone_number.to_s  # Assuming number is in interger form
    @wordlist = {} # Let's store evey wordlist
    # Mapping number to letters
    @number_to_letters_hash_mapping = { '2' => %w[a b c], '3' => %w[d e f], '4' => %w[g h i], '5' => %w[j k l], '6' => %w[m n o], '7' => %w[p q r s], '8' => %w[t u v], '9' => %w[w x y z] }
  end

  def possible_word_combinations
    # Read wordlist file
    read_wordlist_file
    matching_words
  end

  def matching_words
    # Mapping phone number with respective letters
    # mapping_phone_number = [["m", "n", "o"], ["m", "n", "o"], ["t", "u", "v"], ["m", "n", "o"], ["p", "q", "r", "s"], ["t", "u", "v"], ["p", "q", "r", "s"], ["t", "u", "v"], ["a", "b", "c"], ["j", "k", "l"]]   
    @mapping_phone_number = phone_number.chars.map { |char| @number_to_letters_hash_mapping[char] }

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
      # binding.pry
    end
  end

  def read_wordlist_file
    # Categories each word according to their length
    # and store in form of hash
    # since number is mapped in lowercase let's convert all wordlist to lowercase(let's skip this later)
    # wordlist = { 2=>["aa", "ab"....], 3=>["aah", "aal"...], ... }

    File.foreach("dictionary.txt") do |word|
      word = word.chop.downcase
      wordlist[word.length] = wordlist[word.length].nil? ? [word] : wordlist[word.length].push(word)
    end
  end


end


# Let's the method call from here
NumberConversion.new(6686787825).possible_word_combinations
