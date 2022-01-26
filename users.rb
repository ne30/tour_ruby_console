require 'csv'

class User

    private 

    def fetchUserList
        usersInfo = {}
        count = 0

        CSV.foreach("users.csv") do |row|
            if count >= 1
                usersInfo[row[0]] = row[1]
            end
            count = count + 1
        end
        return usersInfo
    end

    def validate(userId, usersInfo)
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
        usersInfo = fetchUserList

        loop do 
            puts "Please enter the new userId to be added"
            userId = gets.chomp
            # puts userId.class
            puts

            if (validate(userId, usersInfo))
                puts "Now please enter the password for the user."
                password = gets.chomp
                if(password.size == 0)
                    next
                end
                puts password

                CSV.open("users.csv", "ab") do |csv|
                    csv << [userId, password]
                end
                puts "User Successfully added."
                return userId
                
                break
            else
                puts "The userId already exist. Try again!"
                puts
            end
        end

    end

    def login
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
                    # puts password.class
                    # puts usersInfo[userId].class
                    password2 = usersInfo[userId]
                    if password2.eql?(password)
                        puts "Login Success"
                        return userId 
                        break
                        # return true
                    else
                        # p password2 
                        # p password
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
end
