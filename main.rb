require './user'
require './tour'
require 'colorize'

user = User.new
tourList = TourList.new

puts
puts "Welcome to the Tours app.".green
puts
userId = ""
gender = ""
loop do 
    puts "Enter 1 to login, 2 to signup and 3 for admin access!".yellow
    puts
    option = gets.chomp
    puts
    if option.eql?("1")
        userId, gender = user.login
    elsif option.eql?("2")
        userId, gender = user.addUser
        next
    elsif option.eql?("3")
        login_status = user.loginAdmin
        if login_status == true 
            userId = "admin"
            gender = "M" 
            user.adminOption
        end
        break
    else
        puts "Wrong option please try again!".red
        puts
        next
    end

    if userId.size > 0 
        break
    end
end

loop do 
    puts "Enter 1 to book new tour or 2 to check your tickets".yellow
    puts
    option = gets.chomp
    puts
    if option.eql?("1")
        tourList.bookTour(userId,gender)
    elsif option.eql?("2")
        user.seeUserTicket(userId)
    else
        puts "Wrong choice please try again!".red
        puts
        next
    end

    puts 
    puts "Do you want to exit? (Y/N)".red
    puts
    option = gets.chomp
    if option.eql?("Y") || option.eql?("y")
        break
    else
        puts
        next
    end
end
