# iex -S mix
# recompile

# list like array
# tuples like array but
defmodule Cards do
  @moduledoc """
  Provides methods for creating and handling cards
  """

  # //function
  # def hello do
  #   "hi there"
  # end

  @doc """
  Returns lists of cards
  """
  def create_deck do
    values = ["Ace", "Two", "Three", "Four", "Five"]
    suits = ["Spades", "Clups", "Hearts", "Diamond"]
    # ////bad
    # for value <- values do
    #   for suit <- suits do
    #     "#{value} of #{suit}"
    #   end
    # end

    # //// good first solution
    # like linked list ==> multiple nested arrays to one array
    # cards =
    #   for(value <- values) do
    #     for suit <- suits do
    #       "#{value} of #{suit}"
    #     end
    #   end

    # List.flatten(cards)

    # /// good secound solution
    for value <- values, suit <- suits do
      "#{value} of #{suit}"
    end
  end

  def shuffle(deck) do
    # arity = argument
    # list of data
    Enum.shuffle(deck)
  end

  # ? => true or false

  @doc """
  Divide deck into hand and the rest of deck
  it returns tuples {[hand],[the rest deck]} it's like {hand:[],rest:[]}

  ## Examples
      iex> deck = Cards.create_deck
      iex> Cards.contains?(deck,"Ace of Spades")
      true
  """
  def contains?(deck, card) do
    Enum.member?(deck, card)
  end

  @doc """
  Divide deck into hand and the rest of deck
  it returns tuples {[hand],[the rest deck]} it's like {hand:[],rest:[]}

  ## Examples
      iex> deck= Cards.create_deck
      iex> deck= Cards.create_deck
  """
  def deal(deck, hand_size) do
    # it returns tuples {[hand],[the rest deck]} it's like {hand:[],rest:[]}
    # {hand,restDeck}=Cards.deal(deck,5)
    Enum.split(deck, hand_size)
  end

  def save(deck, filename) do
    # object to save
    binary = :erlang.term_to_binary(deck)
    File.write(filename, binary)
  end

  def load(filename) do
    {_status, _binary} = File.read(filename)
    # atom(:anything) -> like status code
    case File.read(filename) do
      {:ok, binary} -> :erlang.binary_to_term(binary)
      # _reason -> unused varible don't want to use
      {:error, _reason} -> "error"
    end
  end

  #  crete -> shuffle -> deal
  def create_hand(hand_size) do
    # inject first argument
    Cards.create_deck()
    |> Cards.shuffle()
    |> Cards.deal(hand_size)
  end

  # we don't change the colors array we create new one with new property
  colors = %{primary: "red"}
  Map.put(colors, :primary, "blue")
  # the same as above
  %{colors | primary: "blue"}
  # new key and value
  Map.put(colors, :secoundry, "green")

  colors1 = [{:primary, "red"}, {:secondry, "blue"}]
  # ->out [primary: "red",secondry: "blue"]
  # for serching for value "red"
  colors1[:primary]
end
