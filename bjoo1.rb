#Blackjack OO -- first commit

class Deck
  
  SUITS = ['H', 'D', 'S', 'C']
  CARDS = ['2', '3', '4', '5', '6', '7', '8', '9', '10', 'J', 'Q', 'K', 'A']
  
  def initialize
  @deck1 = []
  end
  
  def shuffle
  @deck1 = CARDS.product(SUITS)
  @deck1 = @deck1.shuffle! 
  end
  
end

class Human
end

class Dealer
end

class Game
  
  def initialize
    @deck = Deck.new
    @human = Human.new
    @dealer = Dealer.new
    @p_hand = []
    @d_hand = []
  end
  
  def total(hand)
    arr = hand.map{|e| e[0] }
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
  
  def player_hand
    @p_hand = @deck.shuffle.pop(2)
    puts "Player has #{@p_hand}."
    player_total = total(@p_hand)
    puts "Players's total is #{player_total}."
      if player_total == 21 
        puts "Player has blackjack!"
        puts "Play again? (Y/N)"
        y=gets.chomp.upcase
        y == "Y" ? Game.new.play : exit
      end
  end
  
  def dealer_hand
    @d_hand = @deck.shuffle.pop(2)
    puts "Dealer has #{@d_hand}."
    dealer_total = total(@d_hand)
    puts "Dealer's total is #{dealer_total}."
      if dealer_total == 21 
        puts "Dealer has blackjack!"
        puts "Play again? (Y/N)"
        y=gets.chomp.upcase
        y == "Y" ? Game.new.play : exit
      end
  end
  
  def player_turn
    loop do
    puts "Hit or stand? (H/S)"
    x=gets.chomp.upcase
    player_total = total(@p_hand)
    if x == "H"
      puts "Player hits."
      @p_hand << @deck.shuffle.pop
      puts "Player has #{@p_hand}."
      player_total = total(@p_hand)
      puts "Players's total is #{player_total}."
        if player_total > 21
          puts "Player went bust."
          puts "Play again? (Y/N)"
          y=gets.chomp.upcase
          y == "Y" ? Game.new.play : exit
        end
    else 
        puts "Player stands with #{player_total}."
        break
    end 
    end
  end
  
  def dealer_turn
    loop do
    dealer_total = total(@d_hand)
    if dealer_total < 17
      puts "Dealer hits."
      @d_hand << @deck.shuffle.pop
      puts "Dealer has #{@d_hand}."
      dealer_total = total(@d_hand)
      puts "Dealer's total is #{dealer_total}."
        if dealer_total > 21
          puts "Dealer went bust."
          puts "Play again? (Y/N)"
          y=gets.chomp.upcase
          y == "Y" ? Game.new.play : exit
        end
    else
      puts "Dealer stands with #{dealer_total}."
      break
    end
    end
  end
    
  def winner
    x=total(@p_hand)<=>total(@d_hand)
      if x == 0 
        puts "It's a tie."
      elsif x == 1 
        puts "Player wins."
      else 
        puts "Dealer wins"
      end
    puts "Play again? (Y/N)"
    y=gets.chomp.upcase
    y == "Y" ? Game.new.play : exit
  end
    
  def play
    puts "Welcome to a new round of Blackjack!"
    @deck.shuffle
    player_hand
    dealer_hand
    player_turn
    dealer_turn
    winner
  end 
end

Game.new.play 
  
