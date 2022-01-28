require 'json'
require 'colorize'

class Ticket

    def saveTicket(userId, tour_code, gender, position)
        # Function to save ticket to JSON file

        json = JSON.parse(File.read('data/tickets.json'))

        if json.key?(userId)
            if json[userId].key?(tour_code)
                puts "You already booked this tour ticket!".green
                puts
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

    def printAllTicket
        json = JSON.parse(File.read('data/tickets.json'))
        json.each do |key, val|
            seeAllTicket(key)
        end
    end

    def seeAllTicket(userId)
        # See all the ticket that is booked by a user
        json = JSON.parse(File.read('data/tickets.json'))
        if !json.key?(userId)
            puts "You have not booked any ticket.".red
            return
        end
        puts "Here is a list of ".blue + userId.green + " booked ticket.".blue
        puts
        ticket_list_hash = json[userId]
        count = 1
        ticket_list_hash.each do |key,val|
            companion = "-"
            if val["position"] == -1
                temp_tour = fetchTour(key)
                printTicket(temp_tour,count,companion)     
            else
                temp_tour = fetchTour(key)  
                if val["position"].even?
                    if ticket_list_hash[key]["gender"].eql?("M") && temp_tour["solo_male_passenger"].size.even?
                        companion = temp_tour["solo_male_passenger"][val["position"]+1]
                    elsif ticket_list_hash[key]["gender"].eql?("F") && temp_tour["solo_female_passenger"].size.even?
                        companion = temp_tour["solo_female_passenger"][val["position"]+1]
                    end
                else
                    if ticket_list_hash[key]["gender"].eql?("M") && temp_tour["solo_male_passenger"].size.even?
                        companion = temp_tour["solo_male_passenger"][val["position"]-1]
                    elsif ticket_list_hash[key]["gender"].eql?("F") && temp_tour["solo_female_passenger"].size.even?
                        companion = temp_tour["solo_female_passenger"][val["position"]-1]
                    end
                end
                printTicket(temp_tour,count,companion)
            end
            count += 1
        end
    end

    def printTicket(tour, counter,companion)
        puts "------------------------------------------------"
        puts "| Serial Number => ".green + counter.to_s.green
        puts "| Tour Code     => ".yellow + tour["tour_code"]
        puts "| From          => ".yellow + tour["from"]
        puts "| To            => ".yellow + tour["to"]
        puts "| Day           => ".yellow + tour["day"]
        puts "| Dep Time      => ".yellow + tour["start_time"]
        puts "| Arr Time      => ".yellow + tour["end_time"]
        puts "| Companion     => ".yellow + companion
        puts "------------------------------------------------"
        puts 
    end
end

# temp = Ticket.new

# temp.seeAllTicket("admin")

