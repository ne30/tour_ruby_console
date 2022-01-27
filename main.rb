require './users'
require './tours'

user = User.new
tourList = TourList.new

puts "Welcome to the Tours app."

userId = ""
gender = ""
loop do 
    puts "Enter 1 to login and 2 to signup!"
    option = gets.chomp
    if option.eql?("1")
        userId, gender = user.login
    elsif option.eql?("2")
        userId, gender = user.addUser
        next
    else
        puts "Wrong option please try again!"
        next
    end

    if userId.size > 0 
        break
    end
end

loop do 
    puts "Enter 1 to book new tour or 2 to check your tickets"
    option = gets.chomp

    if option.eql?("1")
        tourList.bookTour(userId,gender)
    elsif option.eql?("2")
        user.seeUserTicket(userId)
    else
        puts "Wrong choice please try again!"
        next
    end

    puts 
    puts "Do you want to exit? (Y/N)"
    option = gets.chomp
    if option.eql?("Y") || option.eql?("y")
        break
    else
        next
    end
end
