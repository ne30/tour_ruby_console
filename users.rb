require 'csv'
require './tickets'

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
            puts "Please enter the new userId to be added"
            userId = gets.chomp
            puts

            if (validate(userId, usersInfo))
                puts "Now please enter the password for the user."
                password = gets.chomp
                if(password.size == 0)
                    next
                end
                gender = nil
                loop do 
                    puts "Please enter your gender (M or F):"
                    gender = gets.chomp
                    if "M".eql?(gender) or "F".eql?(gender)
                        break
                    else
                        puts "Wrong input please try again!"
                    end
                end

                CSV.open("data/users.csv", "ab") do |csv|
                    csv << [userId, password,gender]
                end
                puts "User Successfully added."
                return userId, gender
                
            else
                puts "The userId already exist. Try again!"
                puts
            end
        end

    end

    def login
        # Login
        usersInfo = fetchUserList
        loop do 
            puts "Please enter userID"
            userId = gets.chomp
            puts
            puts "Please enter password"
            password = gets.chomp
            puts
    
            if userId != nil && userId.size != 0
                if usersInfo.key?(userId)
                    password2 = usersInfo[userId][0]
                    if password2.eql?(password)
                        puts "Login Success"
                        return userId, usersInfo[userId][1]
                    else
                        puts "Wrong Password!"
                    end
                else
                    puts "No such user exist!"
                    puts
                end
            else
                puts "Please try again!"
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