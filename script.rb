use_synth :sine
Dir.chdir('your current directory')

Notes = [:a,:b,:c,:d,:e,:f,:g]

Chords = [nil,:major,:minor, :minor7]

Monogram = ['i','you','the','to','a']

def mapWordToNote(word)
  x = word.length % 7
  y = word.length / 7
  shift = 0
  if one_in(4)
    shift =  (y%3)
  end
  xnote = Notes[x] + shift
  if one_in(7)
    xchord = Chords[x%3]
  end
  return xnote, xchord, x
end


def playN(noteVal, chordType, pauseL)
  isChord = !chordType.nil?
  pauseLength = (pauseL.to_f || 0.00) / 5
  if one_in(8)
    pauseLength = pauseLength * (pauseL%4)
  end
  print pauseLength
  if isChord
    print chordType
    play (chord noteVal, chordType)
  else
    play note noteVal
  end
  sleep pauseLength
end


with_fx :reverb, hall:0.2 do
  live_loop :one do
    f = 'words.txt'
    bias = -10
    File.open(f, 'r:UTF-8') do |fl|
      while l = fl.gets
        str = l.encode!('UTF-8', 'binary', invalid: :replace, undef: :replace, replace: '')
        words = l.split('  ')
        words.each do |w|
          print w
          #e3,5,major
          n,ch,p = mapWordToNote(w)
          playN(n+bias,ch,p)
        end
      end
      fl.close
      print "next"
    end
  end
end
