require 'json'
require './ticket'
require 'colorize'

class Tour
    attr_reader :tour_code, :from, :to, :day, :start_time, :end_time, :max_number_of_passenger, :passenger, :solo_male_passenger, :solo_female_passenger
    
    def initialize(tour_code, from, to, day, start_time, end_time, max_number_of_passenger, passenger, solo_male_passenger, solo_female_passenger)
        @tour_code = tour_code
        @from = from
        @to = to
        @day = day
        @start_time = start_time
        @end_time = end_time
        @max_number_of_passenger = max_number_of_passenger
        @passenger = passenger
        @solo_male_passenger = solo_male_passenger
        @solo_female_passenger = solo_female_passenger
    end

    def to_s 
        @tour_code.to_s.green + " : " + @from.to_s + " => " + @to.to_s + " : " + @day.to_s + " : " + "Remaining Ticket ".green + "=> " + @max_number_of_passenger.to_s.green
    end 

    def compareCode(tour_code)
        return @tour_code.eql?(tour_code)
    end
end

class TourList

    def fetchTour(tour_code)
        # Fetching exact tour detail
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

    def self.fetchTourList
        # Fetching the tourlist from Json

        json = JSON.parse(File.read('data/tours.json'))

        tours =  json["tours"]

        tours_list = []

        tours.each do |tour|
            tour_code = tour["tour_code"]
            from = tour["from"]
            to = tour["to"]
            day = tour["day"]
            start_time = tour["start_time"]
            end_time = tour["end_time"]
            max_number_of_passenger = tour["max_number_of_passenger"]
            passenger = tour["passenger"]
            solo_male_passenger = tour["solo_male_passenger"]
            solo_female_passenger = tour["solo_female_passenger"]

            temp = Tour.new(tour_code, from, to, day, start_time, end_time, max_number_of_passenger, passenger, solo_male_passenger, solo_female_passenger)

            tours_list.push(temp)
        end
        return tours_list
    end

    def self.printAllTour
        tour_list = TourList.fetchTourList
        puts "| TC  : From  => To      :  Day   : Reaminig Ticket".blue
        puts ("--------------------------------------------------------------")
        tour_list.each do |tour|
            print "| "
            puts tour
            puts ("--------------------------------------------------------------")
        end
        puts
    end

    def saveTourList(position, userId, gender)
        #Save the chosem tour for the user

        json = JSON.parse(File.read('data/tours.json'))

        if json["tours"][position]["max_number_of_passenger"] == 0
            puts
            puts "Tour is completely booked.".red
            puts
            return
        end

        temp_ticket = Ticket.new
        solo_size = 0
        if gender.eql?("M")
            solo_size = json["tours"][position]["solo_male_passenger"].size
        else
            solo_size = json["tours"][position]["solo_female_passenger"].size 
        end

        puts
        puts "Do you want a companion/friend during the journey (Y/N).".yellow
        puts
        option = gets.chomp
        puts
        if option.eql?("Y") || option.eql?("y")
            
            ticket_status = temp_ticket.saveTicket(userId, json["tours"][position]["tour_code"], gender, solo_size)
            if ticket_status == false
                return
            end

            if gender.eql?("M")
                json["tours"][position]["solo_male_passenger"].push(userId)
            else
                json["tours"][position]["solo_female_passenger"].push(userId) 
            end
            puts
            puts "Your choice is saved.".green
            puts
        
        else
            ticket_status = temp_ticket.saveTicket(userId, json["tours"][position]["tour_code"], gender, -1)
            if ticket_status == false
                return
            end
            puts
            puts "No companion chosen.".yellow
            puts
        end
        json["tours"][position]["passenger"].push(userId)
        json["tours"][position]["max_number_of_passenger"] -= 1
        File.open("data/tours.json","w") do |f|
            f.write(JSON.pretty_generate(json))
        end
    end
    
    def bookTour(userId, gender)
        # Book a specific tour inputs
        tours_list = TourList.fetchTourList

        puts "Here is the list of available tour :".green
        puts

        TourList.printAllTour

        loop do
            puts "Please enter the tour code (TC) from the above list to book the tour:".yellow
            puts
            option = gets.chomp
            puts
            chosen_tour = nil
            count = 0
            #Hash can be used here
            tours_list.each do |tour|
                if tour.compareCode(option)
                    chosen_tour = tour
                    break
                end
                count = count + 1
            end

            if chosen_tour == nil
                puts "Wrong Option please try again!".red
                puts
            else
                puts "You have chosen :".green
                puts
                puts chosen_tour
                puts
                saveTourList(count, userId, gender)
                break
            end
        end
    end
end

# t = TourList.new

# t.saveTourList(1,"neer","M")