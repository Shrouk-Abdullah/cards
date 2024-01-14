defmodule CardsTest do
  use ExUnit.Case
  doctest Cards

  test "crete deck has 20 cards" do
    deck_length = length(Cards.create_deck())
    assert deck_length == 20
  end

  test "shuffling" do
    card = Cards.create_deck()
    # equal to assert card!=Cards.shuffle(card)
    refute card == Cards.shuffle(card)
  end
  
end
