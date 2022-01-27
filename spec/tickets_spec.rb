require '../tickets'

describe Ticket do
    describe ".saveTicket" do
        context "given an already booked ticket" do
            it "returns false" do
                var = Ticket.new
                expect(var.saveTicket('neer','001','M',1)).to eq(false)
            end
        end

        context "booking a ticket successfully" do
            it "returns true" do
                var = Ticket.new
                expect(var.saveTicket('neer','002','M',1)).to eq(true)
            end
        end        
    end

    describe ".fetchTour" do
        context "Given a wrong tour code" do
            it "return nil" do
                var = Ticket.new
                expect(var.fetchTour("111")).to eq(nil)
            end
        end
    end
end