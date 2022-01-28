require 'json'

json = JSON.parse(File.read('data/tickets_base.json'))

File.open("data/tickets.json","w") do |f|
    f.write(JSON.pretty_generate(json))
end

json = JSON.parse(File.read('data/tours_base.json'))

File.open("data/tours.json","w") do |f|
    f.write(JSON.pretty_generate(json))
end