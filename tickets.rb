require 'json'

class Ticket

    def saveTicket(userId, tour_code, gender, position)
        # Function to save ticket to JSON file

        json = JSON.parse(File.read('data/tickets.json'))

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
        File.open("data/tickets.json","w") do |f|
            f.write(JSON.pretty_generate(json))
        end
        return true
    end

    def fetchTour(tour_code)
        # Fetching exact tour
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
        # See all the ticket that is booked by a user
        json = JSON.parse(File.read('data/tickets.json'))
        if !json.key?(userId)
            puts "You have not booked any ticket."
            return
        end
        ticket_list_hash = json[userId]

        ticket_list_hash.each do |key,val|
            if val["position"] == -1
                temp_tour = fetchTour(key)
                puts temp_tour["tour_code"] + " : " + temp_tour["from"] + " => " + temp_tour["to"] + " : " + temp_tour["day"]        
            else
                temp_tour = fetchTour(key)
                puts temp_tour["tour_code"] + " : " + temp_tour["from"] + " => " + temp_tour["to"] + " : " + temp_tour["day"]        
                if val["position"].even?
                    if ticket_list_hash[key]["gender"].eql?("M") && temp_tour["solo_male_passenger"].size.even?
                        puts "Your companion userId is :" + temp_tour["solo_male_passenger"][val["position"]+1]
                    elsif ticket_list_hash[key]["gender"].eql?("F") && temp_tour["solo_female_passenger"].size.even?
                        puts "Your companion userId is :" + temp_tour["solo_female_passenger"][val["position"]+1]
                    else
                        puts "There is no companion available for you at the moment!"
                    end
                else
                    if ticket_list_hash[key]["gender"].eql?("M") && temp_tour["solo_male_passenger"].size.even?
                        puts "Your companion userId is :" + temp_tour["solo_male_passenger"][val["position"]-1]
                    elsif ticket_list_hash[key]["gender"].eql?("F") && temp_tour["solo_female_passenger"].size.even?
                        puts "Your companion userId is :" + temp_tour["solo_female_passenger"][val["position"]-1]
                    else
                        puts "There is no companion available for you at the moment!"
                    end
                end
            end
        end
    end
    
end

# temp = Ticket.new

# temp.seeAllTicket("neer")