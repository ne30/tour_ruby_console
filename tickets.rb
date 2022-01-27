require 'json'

class Ticket

    def saveTicket(userId, tour_code, gender, position)
        json = JSON.parse(File.read('data/tickets.json'))
        #puts json

        if json.key?(userId)
            if json[userId].key?(tour_code)
                puts "You already booked this tour ticket!"
                return false
            else
                temp_hash = {"gender"=>gender, "position"=>position}
                json[userId][tour_code] = temp_hash
            end
        else
            temp_hash = {"gender"=>gender, "position"=>position}
            json[userId] = {tour_code => temp_hash}
        end
        #puts json
        #puts JSON.pretty_generate(json)
        File.open("data/tickets.json","w") do |f|
            f.write(JSON.pretty_generate(json))
        end
        puts json[userId].keys
        return true
    end

    def fetchTour(tour_code)
        json = JSON.parse(File.read('data/tours.json'))
        tours =  json["tours"]

        #hash may be used
        tours.each do |tour|
            if tour_code.eql?(tour["tour_code"])
                return tour
            end
        end
        return nil
    end

    def seeAllTicket(userId)
        json = JSON.parse(File.read('data/tickets.json'))
        if !json.key?(userId)
            puts "You have not booked any ticket."
            return
        end
        ticket_list_hash = json[userId]

        ticket_list_hash.each do |key,val|
            if val["position"] == -1
                temp = fetchTour(key)
                puts temp["tour_code"] + " : " + temp["from"] + " => " + temp["to"] + " : " + temp["day"]        
            else
                temp = fetchTour(key)
                puts temp["tour_code"] + " : " + temp["from"] + " => " + temp["to"] + " : " + temp["day"]        
                if val["position"].even?
                    if ticket_list_hash[key]["gender"].eql?("M") && temp["solo_male_passenger"].size.even?
                        puts "Your companion userId is :" + temp["solo_male_passenger"][val["position"]+1]
                    elsif ticket_list_hash[key]["gender"].eql?("F") && temp["solo_female_passenger"].size.even?
                        puts "Your companion userId is :" + temp["solo_female_passenger"][val["position"]+1]
                    else
                        puts "There is no companion available for you at the moment!"
                    end
                else
                    if ticket_list_hash[key]["gender"].eql?("M") && temp["solo_male_passenger"].size.even?
                        puts "Your companion userId is :" + temp["solo_male_passenger"][val["position"]-1]
                    elsif ticket_list_hash[key]["gender"].eql?("F") && temp["solo_female_passenger"].size.even?
                        puts "Your companion userId is :" + temp["solo_female_passenger"][val["position"]-1]
                    else
                        puts "There is no companion available for you at the moment!"
                    end
                end
            end
        end
    end
    
end

# temp = Ticket.new

# temp.saveTicket("admin2","001","M",-1)