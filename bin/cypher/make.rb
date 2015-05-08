#! /usr/bin/ruby

#puts "CREATE CONSTRAINT ON (p:Pkg) ASSERT p.path IS UNIQUE;"

pkgs = File.read('var/packages').lines
pkgs = pkgs[0..2]

pkgs.map { |pkg| pkg.chomp!; pkg}.uniq

deps = pkgs.map do |p|
  deps = %x{GOPATH=var/go go list -f '{{ join .Deps "\\n" }}' '#{p}'}.lines
  deps.each { |d| d.chomp!; d }
  deps
end.flatten.uniq

nodes = (pkgs + deps).uniq

nodes.each_with_index.map do |p, i|
  "(p#{i}:Pkg { path: '#{p}'})"
end

#puts "CREATE #{nodes.join(',')}"


#puts "MATCH #{pkgs.each_with_index.map {|p,i| "(p#{i})"}.join(', ') } WHERE #{ pkgs.each_with_index.map {|p,i| "p#{i}.path = '#{p}'" }.join(' AND ') }"

matches = []
creates = []
pkgs.each_with_index do |p,i|
  deps = %x{GOPATH=var/go go list -f '{{ join .Imports "\\n" }}' '#{p}'}.lines
  deps.each_with_index do |d,j|
    d.chomp!
    matches << "MATCH (p#{i}:Pkg), (d#{i}d#{j}:Pkg) WHERE p#{i}.path = \"#{p}\" AND d#{i}d#{j}.path = \"#{d}\""
    creates << "CREATE (p#{i})-[:IMPORTS]->(d#{i}d#{j})"
  end


end
puts matches
puts creates
