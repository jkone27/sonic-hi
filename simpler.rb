
#good one

Dir.chdir('C:\Users\Giacomo\Desktop')

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

def mapWordToNote(word)
  if (Possession).include? word.downcase then
    Notes[word.length]
  else
    scale(:A2, [:minor].sample, num_octaves: 1).reverse[word.length]
  end
end

def playN(notes)
  with_fx :reverb, mix:0.8, amp:0.2 do
    with_fx :lpf, cutoff: 100 do
      use_synth Synthetizers['sin']
      play_pattern_timed notes, [0.3,0.4].sample
    end
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

#https://freesound.org/ -
#https://freesound.org/people/straget/sounds/412308/

live_loop :samp do
  sample "samples",1
  sleep sample_duration "samples",1
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