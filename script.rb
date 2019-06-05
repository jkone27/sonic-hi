Dir.chdir('script dir')


Synthetizers = {
  'sine' => :sine,
  'saw' => :saw,
  'pulse' => :pulse,
  'fm' => :fm,
  'dsaw' => :dsaw,
  'tb303' => :tb303,
  'prophet' => :prophet
}

Notes = [:a,:b,:c,:d,:e,:f,:g]

Chords = [nil,:major,:minor, :minor7]

Monogram = {
  'i' => nil,
  'you' => :a4 + 0.5,
  'the' => :c6,
  'to' => :f6,
  'a' => :d6 + 0.5
}

GoldenRatio = 1.618034

def mapWordToNote(word)
  x = word.length % 7
  y = word.length / 7
  shift = 0
  if one_in(4)
    shift = (y%3)
  end
  xnote = Notes[x] + shift
  if one_in(7)
    xchord = Chords[x%3]
  end
  return xnote, xchord, x
end


def playN(noteVal, chordType, pauseL)
  use_synth Synthetizers['fm']
  isChord = !chordType.nil?
  rel = pauseL * GoldenRatio
  pauseLength = (pauseL.to_f || 0.00) / 5
  if one_in(8)
    pauseLength = pauseLength * (pauseL%4)
  end
  if one_in(7)
    use_synth Synthetizers['sine']
  end
  print pauseLength
  if isChord
    print chordType
    
    play (chord noteVal, chordType), sustain: rel
  else
    
    play note noteVal, release: rel
  end
  sleep pauseLength
end

def cleanString(str)
  str.encode!('UTF-8', 'binary', invalid: :replace, undef: :replace, replace: '')
end

live_loop :beats do
  sample :bd_808, compress: 1
  sleep 1
end


with_fx :reverb, hall:0.2 do
  live_loop :one do
    f = 'words.txt'
    bias = -10
    File.open(f, 'r:UTF-8') do |fl|
      while l = fl.gets
        str = cleanString(l)
        words = l.split('  ')
        words.each do |w|
          print w
          #e3,5,major
          if !Monogram[w].nil?
            print 'monogram'
            n,ch,p = Monogram[w],nil,1
          else
            n,ch,p = mapWordToNote(w)
          end
          playN(n+bias,ch,p)
        end
      end
      fl.close
      print "next"
    end
    
  end
end
