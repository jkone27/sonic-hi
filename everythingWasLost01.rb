
Dir.chdir('C:\Users\Giacomo\Desktop')

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

[1,2,3,4,5].each do |n|
  Notes
end

def mapWordToNote(word)
  x = word.length % 7
  shift = (Notes[6] + 20) - word.length
  xnote = Notes[x] + shift
  return xnote > 0 ? xnote : Notes[0]
end


def playN(noteVal, chordType)
  with_fx :reverb, hall:0.2 do
    use_synth Synthetizers['fm']
    isChord = !chordType.nil?
    rel = if one_in(5) then noteVal / GoldenRatio else GoldenRatio/3 end
    if one_in(7)
      use_synth Synthetizers['sine']
    end
    if isChord
      print chordType
      
      play (chord noteVal, chordType), sustain: rel
    else
      
      play note noteVal, release: rel
    end
  end
end

def cleanString(str)
  str.encode!('UTF-8', 'binary', invalid: :replace, undef: :replace, replace: '')
end


def DrumsLoop(drumPauseVariation, drumRateVariation)
  with_fx :reverb, hall:0.8 do
    with_fx  :distortion, mix:0.1,pre_amp:1 do
      #live_loop :beats do
      sample :bd_808, amp:10, compress:1
      sleep 0.94
      #end
      #live_loop :snares do
      sleep GoldenRatio * 0.3 * drumPauseVariation
      sample :drum_snare_soft, rate:1.5 * drumRateVariation, amp:0.9
      #end
    end
  end
end


live_loop :one do
  f = 'words.txt'
  bias = -10
  File.open(f, 'r:UTF-8') do |fl|
    while l = fl.gets
      str = cleanString(l) #utf-8
      if (str.start_with? "//") then next end
      words = l.split(' ')
      words.each do |w|
        print w
        #e3,5,major
        wlower = w.downcase
        if !Monogram[wlower].nil?
          print 'monogram'
          n,ch = Monogram[wlower],:major7
        else
          n,p = mapWordToNote(w)
          ch = nil
        end
        ps = (p.to_f || 0.00) / 5
        in_thread do
          drumVary = (ps < 1 ? 1 : ps)
          DrumsLoop(w.length, drumVary)
          sleep 0.5
          playN(n+bias,ch)
        end
      end
      sleep (if one_in(3) then 1 else GoldenRatio end)
    end
    fl.close
    print "next"
  end
end
