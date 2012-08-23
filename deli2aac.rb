#!/usr/bin/env ruby
# encoding: utf-8

require 'colored'

def process_file(path)
  puts "\nProcessing ‘#{path}’".green
  info = `uade123 -g "#{path}" 2>&1`
  
  # subsong_info: 1 x y (cur, min, max)
  if subsong_matches = info.match(/subsong_info: 1 \d (\d)/)
    songs = subsong_matches[1].to_i
    if songs > 1
      puts "↪ Contains #{songs.to_s.bold} songs"
      1.upto(songs.to_i) do |subsong|
        output_song(path, subsong)
      end      
    else
      output_song(path)
    end
  else
    puts "The file ‘#{path}’ contained no songs".red
  end
end

def output_song(path, subsong=nil)
  unless subsong.nil?
    wav_path = "#{path}_#{sprintf('%02d', subsong)}.wav"
    caf_path = "#{path}_#{sprintf('%02d', subsong)}.caf"
    m4a_path = "#{path}_#{sprintf('%02d', subsong)}.m4a"    
  else
    wav_path = "#{path}.wav"
    caf_path = "#{path}.caf"
    m4a_path = "#{path}.m4a"
  end
  
  puts "↪ Exporting  #{path.yellow}:#{subsong.nil? ? 1 : subsong}   → #{wav_path.green}"
  `uade123 --headphones --subsong=#{subsong} --one -f "#{wav_path}" "#{path}" 2>&1`
  
  puts "↪ Converting #{wav_path.yellow} → #{caf_path.green}"
  `afconvert "#{wav_path}" "#{caf_path}" -d 0 -f caff --soundcheck-generate`
  
  puts "↪ Encoding   #{caf_path.yellow.bold} → #{m4a_path.green.bold}"
  `afconvert "#{caf_path}" -d aac -f m4af -u pgcm 2 --soundcheck-read -b 256000 -q 127 -s 2 "#{m4a_path}"`
  
  `rm "#{wav_path}" "#{caf_path}"`
end

# check that uade123 and afconvert are present
dependencies = ['uade123', 'afconvert']

if dependencies.all? {|dep| !`which #{dep}`.empty? }
  unless ARGV.length == 0
    ARGV.each do |arg|
      if File.exists? arg
        if File.directory? arg
          Dir.entries(arg).each do |entry|
            process_file "#{arg}/#{entry}" unless entry.match /^\./
          end
        else
          process_file arg
        end
        puts "\nDone!".bold
      else
        puts "No file or directory ‘#{arg}’ exists.".red
      end
    end
  else
    puts "Usage: deli2aac [files]"
  end
else
  # dependencies aren't met
  puts "Required dependency(s) missing.\n".red
  
  dependencies.each do |dep|
    puts "* #{dep}".red if `which #{dep}`.empty?
  end
  
  puts "\nafconvert is included with the Mac OS X Developer Tools, and uade can be installed with HomeBrew.".red
end