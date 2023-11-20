require 'date'
require_relative 'Item'

class Game < Item
  attr_accessor :multiplayer, :last_played_at

  def initialize(last_played_at: nil, multiplayer: false, id: nil, publish_date: nil, archived: false)
    super(id, publish_date, archived)

    raise ArgumentError, 'multiplayer must be a Boolean' unless multiplayer.is_a?(Boolean)

    @multiplayer = multiplayer
    @last_played_at = last_played_at
  end

  def can_be_archived?
    return false if @last_played_at.nil?

    current_date = Date.today
    last_played_date = Date.parse(@last_played_at)

    super && (last_played_date < current_date - (365 * 2))
  end
end
