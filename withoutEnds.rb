# composition without ends
live_loop :test2 do
  play_pattern_timed scale(:c2, :major, num_octaves: 2).reflect, 0.3, release: 0.1
end

live_loop :test do
  play chord(:A3, :minor)
  
  play_pattern chord(:E3, :m7)
  
  sleep 0.3
end

live_loop :drums do
  with_fx :reverb, hall:0.8 do
    with_fx  :distortion, mix:0.1,pre_amp:1 do
      #live_loop :beats do
      sample :bd_ada, amp:10, compress:1
      sleep 0.94
      #end
      #live_loop :snares do
      sleep 1.6180 * 0.3
      sample :drum_snare_hard, rate:1.5, amp:0.9
      #end
    end
  end
end

