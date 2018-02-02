require 'minitest/autorun'
require './blackjack'

class TestBlackjack < Minitest::Test

  def create_deck_stub(card_values)
    suits = ['H']
    @cards = []
    card_values.each do |card_value|
      suits.each do |suit|
        @cards << Card.new(suit, card_value)
      end
    end
    @cards
  end

  def test_one_ace_with_value_11
    player = Player.new
    hand = create_deck_stub([2, 'A', 8])
    player.cards = hand
    assert_equal 21, player.total(player.cards)
  end

  def test_one_ace_value_changes_to_1
    player = Player.new
    hand = create_deck_stub([2, 'A', 9])
    player.cards = hand
    assert_equal 12, player.total(player.cards)
  end

  def test_two_aces_with_different_values
    player = Player.new
    hand = create_deck_stub([2, 'A', 'A'])
    player.cards = hand
    assert_equal 14, player.total(player.cards)
  end

  def test_three_two_aces
    player = Player.new
    hand = create_deck_stub(['A', 'A', '3', 'A', '5'])
    player.cards = hand
    assert_equal 21, player.total(player.cards)
  end
end
