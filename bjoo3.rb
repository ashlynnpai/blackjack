#Blackjack OO -- second commit -- work in progress

class Deck
  attr_accessor :deck
  
  SUITS = ['H', 'D', 'S', 'C']
  CARDS = ['2', '3', '4', '5', '6', '7', '8', '9', '10', 'J', 'Q', 'K', 'A']
  
  def initialize
  @deck = []
  end
  
  def shuffle
  @deck1 = CARDS.product(SUITS)
  @deck1 = @deck1.shuffle! 
  end
  
end

module Hand

def hand(person, cards)
    cards.each do|card|
      puts "#{card}"
     #puts "=> Total: #{total}"
    end
    
def total(cards)
    arr = cards.map{|e| e[0] }
    total = 0
      arr.each do |value|
        if value == "A"
        total += 11
        elsif value.to_i == 0 # J, Q, K
        total += 10
        else
        total += value.to_i
        end
      end
    #correct for Aces
    arr.select{|e| e == "A"}.count.times do
    total -= 10 if total > 21
    end
    total
  end
end
end

class Player
  attr_accessor :name, :cards
  
   include Hand

  def initialize(n)
    @name = n
    @cards = []
  end
    
end

class Dealer
  attr_accessor :name, :cards
  
    include Hand

  def initialize
    @name = "Dealer"
    @cards = []
  end
end

class Game
  attr_accessor :deck, :player, :dealer, :p_hand, :d_hand
  
  def initialize
    @deck = Deck.new
    @player = Player.new("Player1")
    @dealer = Dealer.new
    @p_hand = []
    @d_hand = []
  end
  
  def new_game
    puts "Play again? (Y/N)"
    y=gets.chomp.upcase
    y == "Y" ? Game.new.play : exit
  end
  
  def report_total
    player_total = player.total(@p_hand)
    puts "Player's total is #{player_total}."
    dealer_total = dealer.total(@d_hand)
    puts "Dealer's total is #{dealer_total}."
  end
  

    def blackjack
    player_total = player.total(@p_hand)
    dealer_total = dealer.total(@d_hand)
    report_total  
    if (player_total == 21) && (dealer_total == 21) 
      puts "Tie!"
      new_game
    elif player_total == 21 
      puts "Player wins!"
      new_game
    elif dealer_total == 21 
      puts "Dealer wins!"
      new_game
    end
    nil
  end
  
  def player_deal
    @deck=@deck.shuffle
    @p_hand = @deck.pop(2)
    puts "Player's cards"
    player.hand("Player 1", @p_hand)
  end
  
  def dealer_deal
    @d_hand = @deck.pop(2)
    puts "Dealer's cards"
    dealer.hand("Dealer", @d_hand)
  end
   
  def player_turn
    loop do
      puts "Hit or stand? (H/S)"
      x=gets.chomp.upcase
      player_total = player.total(@p_hand)
      if x == "H"
        puts "Player hits."
        @p_hand << @deck.pop
        player.hand("Player 1", @p_hand)
        report_total
          if player_total > 21
            puts "Player went bust."
            new_game
          end
      else 
          puts "Player stands with #{player_total}."
          break
      end 
    end
  end
  
  def dealer_turn
    loop do
    dealer_total = dealer.total(@d_hand)
    if dealer_total < 17
      puts "Dealer hits."
      @d_hand << @deck.pop
      dealer.hand("Dealer", @d_hand)
      report_total
        if dealer_total > 21
          puts "Dealer went bust."
          new_game
        end
    else
      puts "Dealer stands with #{dealer_total}."
      break
    end
    end
  end
    
  def winner
    player_total = player.total(@p_hand)
    dealer_total = dealer.total(@d_hand)
    report_total
    x= player_total<=>dealer_total
      if x == 0 
        puts "It's a tie."
      elsif x == 1 
        puts "Player wins."
      else 
        puts "Dealer wins"
      end
    new_game
  end
    
  def play
    player_deal
    dealer_deal
    blackjack
    player_turn
    dealer_turn
    winner  
  end 
end

Game.new.play 
  
