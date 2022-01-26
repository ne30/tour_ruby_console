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
    # puts option.class
    if option.eql?("1")
        userId, gender = user.login
    elsif option.eql?("2")
        userId, gender = user.addUser
    else
        puts "Wrong option please try again!"
        next
    end

    if userId.size > 0 
        break
    end
end

# p user.fetchUserList
p userId
p gender

tours_list = tourList.fetchTourList

puts "Here is the list of available tour :"
puts "TC  : From   => To     : Day"
puts
tours_list.each do |tour|
    puts tour
end


loop do
    puts "Please enter the tour code (TC) from the above list to book the tour:"
    option = gets.chomp
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
        puts "Wrong Option please try again!"
    else
        puts "You have chosen :"
        puts chosen_tour
        # tours_list[count].passenger.push(userId)
        # p tours_list[count]
        tourList.saveTourList(count, userId, gender)
        break
    end
end