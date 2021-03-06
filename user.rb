require 'csv'
require 'fancy_gets'
require 'colorize'

require './ticket'
require './tour'

include FancyGets

class User

    private 

    def fetchUserList
        # Fetching the user list from csv file
        users_info = {}
        count = 0

        CSV.foreach("data/users.csv") do |row|
            if count >= 1
                users_info[row[0]] = [row[1], row[2]]
            end
            count = count + 1
        end
        return users_info
    end

    def validate(userId, users_info)
        # Validatio the userId if it is valid i.e. not nil and not similar
        if userId == nil || userId.size == 0
            return false
        elsif users_info.key?(userId)
            return false
        else
            return true
        end 
    end

    public

    def addUser
        # Signup
        users_info = fetchUserList

        loop do 
            puts "Please enter the new userId to be added".blue
            puts
            userId = gets.chomp
            puts

            if userId.size <= 2
                puts "Please enter userId of size greater than 3!".red
                puts
                next
            end
            if (validate(userId, users_info))
                puts "Now please enter the password for the user.".blue
                puts
                password = gets_password
                puts
                if(password.size == 0)
                    next
                end
                gender = nil
                loop do 
                    puts "Please enter your gender (M or F):".blue
                    puts
                    gender = gets.chomp
                    puts
                    if "M".eql?(gender) or "F".eql?(gender)
                        break
                    else
                        puts "Wrong input please try again!".red
                        puts
                    end
                end

                CSV.open("data/users.csv", "ab") do |csv|
                    csv << [userId, password, gender]
                end
                puts "User Successfully added.".green
                puts
                return userId, gender
                
            else
                puts "The userId already exist. Try again!".red
                puts
            end
        end

    end

    def login
        # Login
        users_info = fetchUserList
        loop do 
            puts "Please enter userID".blue
            puts
            userId = gets.chomp
            puts
            puts "Please enter password".blue
            puts
            password = gets_password
            puts
    
            if userId != nil && userId.size != 0
                if users_info.key?(userId)
                    stored_password = users_info[userId][0]
                    if stored_password.eql?(password)
                        puts "Login Success".green
                        puts
                        return userId, users_info[userId][1]
                    else
                        puts "Wrong Password!".red
                    end
                else
                    puts "No such user exist!".red
                    puts
                end
            else
                puts "Please try again!".red
            end
        end
    end

    def seeUserTicket(userId)
        # Printing the user booked ticket
        temp_ticket = Ticket.new
        temp_ticket.seeAllTicket(userId)
    end

    def adminOption
        loop do 
            puts "Enter 1 to see all tours, 2 to see all booked ticket or 3 to exit from these options".yellow
            puts
            option = gets.chomp
            puts
            if option.eql?("1")
                TourList.printAllTour
                next
            elsif option.eql?("2")
                Ticket.new.printAllTicket
                next
            elsif option.eql?("3")
                puts "You are going back in the main application!".blue
                puts
                return
            else
                puts "Wrong option please try again!".red
                puts
                next 
            end
        end
    end

    def loginAdmin
        loop do 
            puts "Please enter userID".blue
            puts
            userId = gets.chomp
            puts
            puts "Please enter password".blue
            puts
            password = gets_password
            puts

            if "admin".eql?(userId) && "admin".eql?(password)
                return true
            else
                puts "Wrong Credentials! Try again!".red
                puts
                next
            end
        end
    end
end


# If not commented it will run as intended before importing 
# temp = User.new

# temp.login