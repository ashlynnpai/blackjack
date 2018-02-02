require 'minitest/autorun'
require './blackjack'

class TestBlackjack < Minitest::Test
  def test_two_aces_with_different_values
    deck = Deck.new
    def deck.create_deck
      card_values = [2, 'A', 'A']
      suits = ['H']
      @cards = []
      card_values.each do |card_value|
        suits.each do |suit|
          @cards << Card.new(suit, card_value)
        end
      end
      @cards
    end
    hand = deck.create_deck
    puts hand
    player = Player.new
    player.cards = hand
    assert_equal 14, player.total(player.cards)
  end
end



# 2 A A should be 14
#
# 2 3 A should be 16
#
# 2 A 8 should be 21
#
# 2 A 9 should be 12
#
# A 3 2 8 should equal 14
