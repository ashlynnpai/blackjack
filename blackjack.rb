class Card
  attr_accessor :suit, :value

  def initialize(suit, value)
    @suit = suit
    @value = value
  end

  def to_s
    "#{value} of #{suit}"
  end
end

class Deck
  attr_accessor :cards

  SUITS = ['H', 'D', 'S', 'C']
  CARDS = ['2', '3', '4', '5', '6', '7', '8', '9', '10', 'J', 'Q', 'K', 'A']

  def initialize
    @cards = []
  end

  def create_deck
    @cards = []
    2.times do
      CARDS.each do |card|
        SUITS.each do |suit|
          @cards << Card.new(suit, card)
        end
      end
    end
    @cards = @cards.shuffle!
  end
end

module Hand

  def hand(person, cards)
    puts "\n#{person}'s hand is:\n"
    cards.each do|card|
      puts card
    end
  end

  def total(cards)
    add_values = cards.map{|card| card.value }
    total = 0
      add_values.each do |value|
          if value == "A"
        total += 11
          elsif value.to_i == 0 # J, Q, K
        total += 10
          else
        total += value.to_i
        end
      end
    #correct for Aces
    add_values.select{|card| card == "A"}.count.times do
        total -= 10 if total > 21
      end
    total
    end
  end

class Participant
  attr_accessor :name, :cards

  include Hand

  def initialize(name = nil)
    @name = name
    @cards = []
  end
end

class Player < Participant

end

class Dealer < Participant

  def first_hand(cards)
    puts "First card is hidden."
    puts "Second card is #{cards[1]}\n"
  end
end

class Game
  attr_accessor :deck, :player, :dealer, :tracker

  def initialize
    @tracker = {}
  end

  def new_game
    puts "Play again? (Y/N)"
    answer = gets.chomp.upcase
    answer == "Y" ? restart_game : exit
  end

  def blackjack
    winners = []
    tracker[player.name] = player.total(player.cards)
    tracker[dealer.name] = dealer.total(dealer.cards)
    tracker.each {|k,v| winners << k if v == 21}
    if winners.length > 0
      puts "\nWinning with blackjack are: \n"
      winners.each {|winner| puts winner}
      new_game
    end
  end

  def start_game
    puts "Welcome to Blackjack!\n"
    puts "What is Player's name?"
    @player = Player.new
    @player.name = gets.chomp
    @dealer = Dealer.new("Dealer")
    puts "\nWelcome #{player.name}!\n"
  end

  def initial_deal
    @deck = Deck.new.create_deck
    player.cards = @deck.pop(2)
    player.hand(player.name, player.cards)
    dealer.cards = @deck.pop(2)
    puts "\n#{dealer.name}'s hand is:\n"
    dealer.first_hand(dealer.cards)
  end

  def player_turn
    loop do
      puts "Hit or stand? (H/S)"
      decide = gets.chomp.upcase
      if decide == "H"
        get_card(player)
        break if tracker[player.name] == 21
        break if check_for_bust(player)
      else
        puts "\n#{player.name} stands with #{tracker[player.name]}.\n"
        break
      end
    end
  end

  def dealer_turn
    dealer.hand("Dealer", dealer.cards)
    tracker[dealer.name] = dealer.total(dealer.cards)
    puts "\n#{dealer.name}'s total is #{tracker[dealer.name]}.\n"
    loop do
      if tracker[dealer.name] < 17
        get_card(dealer)
        break if check_for_bust(dealer)
      else
        puts "\n#{dealer.name} stands with #{tracker[dealer.name]}.\n"
        break
      end
    end
  end

  def get_card(participant)
    puts "#{participant.name} hits.\n"
    participant.cards << @deck.pop
    participant.hand(participant.name, participant.cards)
    tracker[participant.name] = participant.total(participant.cards)
    puts "\n#{participant.name}'s' total is #{tracker[participant.name]}.\n"
  end

  def check_for_bust(participant)
    if tracker[participant.name] > 21
      puts "#{participant.name} went bust."
      true
    end
  end

  def winner
    winners = []
    tracker.each do |k,v|
      if winners.length > 0
        if v > tracker[winners[0]] && v < 22
          winners = []
          winners << k
        elsif v == tracker[winners[0]]
          winners << k
        end
      elsif v < 22
        winners << k
      end
    end
    puts "\nThe winners are: \n"
    winners.each {|winner| puts winner}
    new_game
  end

  def play
    initial_deal
    blackjack
    player_turn
    dealer_turn
    winner
  end

  def restart_game
    puts "Welcome to a new round of Blackjack!\n"
    @deck = Deck.new
    player.cards = []
    dealer.cards = []
    play
  end

  def first_play
    start_game
    play
  end
end

Game.new.first_play
