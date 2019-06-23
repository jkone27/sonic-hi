
#good one

Dir.chdir('C:\Users\Giacomo\Desktop')
#https://freesound.org/

Notes = [:a,:b,:c,:d,:e,:f,:g].ring

GoldenRatio = 1.618034


Possession = [
  'i',
  'you',
  'me',
  'us',
  'we',
  'they',
  'them',
  'ours',
  'theirs',
  'yours'
]

Action = [
  'make',
  'do',
  'tell',
  'call',
  'ask',
  'give',
  'take',
  'bring',
  'talk',
]

Others = [
  'to',
  'the',
  'and',
  'a',
  'that',
  'it',
  'not',
  'as',
  'this',
  'but',
  'where',
  'why'
]

def mapWordToNote(word)
  if (Possession).include? word.downcase then
    play chord(Notes[word.length], :minor)
  else
    scale(:A2, [:minor].sample, num_octaves: 1).reverse[word.length]
  end
end

def playN(notes)
  with_fx :reverb, mix:0.5 do
    use_synth Synthetizers['sin']
    play_pattern_timed notes, [0.3,0.4].sample
  end
end

def cleanString(str)
  str.encode!('UTF-8', 'binary', invalid: :replace, undef: :replace, replace: '')
end


def playLine(l)
  bias = -10
  str = cleanString(l) #utf-8
  if (str.start_with? "//") then raise ArgumentError, "jump" end
  words = l.split(' ')
  
  notes = words.map{|w| mapWordToNote(w) }
  
  playN(notes)
  #words.each do |w|
  #sleep GoldenRatio/3
end


live_loop :one do
  #def ReadFileAndLoop()
  f = 'words.txt'
  File.open(f, 'r:UTF-8') do |fl|
    while l = fl.gets
      begin
        print l
        playLine(l)
      rescue ArgumentError => a
        next
      end
    end
    fl.close
    print "next"
  end
end