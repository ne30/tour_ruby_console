require 'csv'
require './ticket'
require 'fancy_gets'

include FancyGets

class User

    private 

    def fetchUserList
        # Fetching the user list from csv file
        usersInfo = {}
        count = 0

        CSV.foreach("data/users.csv") do |row|
            if count >= 1
                usersInfo[row[0]] = [row[1], row[2]]
            end
            count = count + 1
        end
        return usersInfo
    end

    def validate(userId, usersInfo)
        # Validatio the userId if it is valid i.e. not nil and not similar
        if userId == nil || userId.size == 0
            return false
        elsif usersInfo.key?(userId)
            return false
        else
            return true
        end 
    end

    public

    def addUser
        # Signup
        usersInfo = fetchUserList

        loop do 
            puts "Please enter the new userId to be added".blue
            puts
            userId = gets.chomp
            puts

            if (validate(userId, usersInfo))
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
                    csv << [userId, password,gender]
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
        usersInfo = fetchUserList
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
                if usersInfo.key?(userId)
                    password2 = usersInfo[userId][0]
                    if password2.eql?(password)
                        puts "Login Success".green
                        puts
                        return userId, usersInfo[userId][1]
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

end


# If not commented it will run as intended before importing 
# temp = User.new

# temp.login