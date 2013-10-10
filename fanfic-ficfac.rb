#!/usr/bin/ruby


class String
  def swap_letters
    return self if self.size <= 1    

    n1 = rand(self.size-1)
    begin
      n2 = n1 + ((-1..1).to_a-[0]).shuffle.first
    end while n2 < 0 || n2 >= self.size

    new_string = self.dup
    new_string[n1] = self[n2]
    new_string[n2] = self[n1]
    new_string  
  end

  def self.consonants
    @@consonants ||= ('a'..'z').to_a - %w(a e i o u y)
  end
  
  def insert_consonant
    where = rand(self.size)
    self.split("").insert(where, String.consonants.shuffle.first).join
  end
end

in_file_name = ARGV[0]
out_file_name = ARGV[1]

text = []

short_words = %w[a is of the]
shit_phrases = [", bitch.", ". YOLO!", " lol."]

out_file = File.open out_file_name, 'w'

i = 0

File.open(in_file_name, 'r').each_line do |line|
  print "\r#{i+=1}";
  
  words = line.split " "
  
  new_words = []

  words.each do |w|
    r = rand(6)

    case r
      when 0
        w = w.swap_letters
      when 1
        w = w.insert_consonant
    end

    new_words << w
  end
  
  if (1..4).to_a.shuffle.first == 1 && new_words.size > 3
    new_words.insert(rand(new_words.size-1), short_words.shuffle.first)
  end

  line = new_words.join(" ")
  
  full_stop_position = line.index "."
  if full_stop_position && rand(50) == 1
    line.sub! ".", shit_phrases[rand(shit_phrases.size)]
  end
  
  out_file.write line + "\n"
  text = []
end

out_file.close