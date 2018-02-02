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
    puts "\n#{name} hand is:\n"
    puts "First card is hidden."
    puts "Second card is #{cards[1]}\n"
  end
end

class Npc < Participant

end

class Game
  attr_accessor :deck, :player, :dealer, :npcs, :tracker

  def initialize
    @tracker = {}
    @npcs = []
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
    npcs.each {|npc| tracker[npc.name] = npc.total(npc.cards)}
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
    puts "\nWelcome #{player.name}!"
    number_npcs = select_number_npcs
    create_npcs(number_npcs)
  end

  def create_npcs(number)
    names = ["Elvis", "Wynning", "Caesar", "Lucky"]
    index = 0
    number.times do
      npcs << Npc.new(names[index])
      index += 1
    end
    if number > 0
      puts "\nIntroducing the other players:"
      npcs.each {|npc| puts "#{npc.name}"}
    end
  end

  def select_number_npcs
    while true do
      puts "\nHow many computer players do you want in the game? Select 0-4"
      number_npcs = gets.chomp
      begin
        number_npcs = Integer(number_npcs)
        break if number_npcs >= 0 && number_npcs <= 4
      rescue
        puts "Not a valid number"
      end
    end
    return number_npcs
  end

  def initial_deal
    @deck = Deck.new.create_deck
    deal_each(player)
    player.hand(player.name, player.cards)
    deal_each(dealer)
    dealer.first_hand(dealer.cards)
    if npcs.length > 0
      npcs.each { |npc| deal_each(npc) }
    end
  end

  def deal_each(participant)
    participant.cards = @deck.pop(2)
  end

  def player_turn
    loop do
      puts "\nHit or stand? (H/S)"
      decide = gets.chomp.upcase
      if decide == "H"
        get_card(player)
        break if tracker[player.name] == 21
        break if check_for_bust(player)
      elsif decide == "S"
        puts "\n#{player.name} stands with #{tracker[player.name]}.\n"
        break
      end
    end
  end

  def computer_turn(participant)
    participant.hand(participant.name, participant.cards)
    tracker[participant.name] = participant.total(participant.cards)
    puts "\n#{participant.name}'s total is #{tracker[participant.name]}.\n"
    loop do
      if tracker[participant.name] < 17
        get_card(participant)
        break if check_for_bust(participant)
      else
        puts "\n#{participant.name} stands with #{tracker[participant.name]}.\n"
        break
      end
    end
  end

  def npc_turn
    if npcs.length > 0
      npcs.each do |npc|
        computer_turn(npc)
      end
    end

  end

  def dealer_turn
    computer_turn(dealer)
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
    puts "House wins" if winners.length == 0
    new_game
  end

  def play
    initial_deal
    blackjack
    player_turn
    npc_turn
    dealer_turn
    winner
  end

  def restart_game
    puts "Welcome to a new round of Blackjack!\n"
    @deck = Deck.new
    player.cards = []
    dealer.cards = []
    npcs.each {|npc| npc.cards = []}
    play
  end

  def first_play
    start_game
    play
  end
end

#Game.new.first_play
