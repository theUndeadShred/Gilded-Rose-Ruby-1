class GildedRose
  attr_reader :name, :days_remaining, :quality

  def initialize(name:, days_remaining:, quality:)
    @name = name
    @days_remaining = days_remaining
    @quality = quality
  end

  INCREASING_ITEMS =
    ['Aged Brie', 'Backstage passes to a TAFKAL80ETC concert'].freeze

  CONJURED_ITEMS  = ['Conjured Mana Cake'].freeze
  LEGENDARY_ITEMS = ['Sulfuras, Hand of Ragnaros'].freeze

  QUALITY_MAX = 50
  QUALITY_MIN = 0


  # TODO: Ask Allison why we decrease the shelf life halfway through?
  def tick
    return if legendary_item?
    age_increases_item_value? ? daily_quality_increase : daily_quality_decrease
    decrease_shelf_life
    zero_out_tickets
  end

  private

  def age_increases_item_value?
    INCREASING_ITEMS.include? name
  end

  def ticket_item?
    name == 'Backstage passes to a TAFKAL80ETC concert'
  end

  def conjured_item?
    CONJURED_ITEMS.include? name
  end

  def legendary_item?
    LEGENDARY_ITEMS.include? name
  end

  def quality_can_decrease?
    quality > QUALITY_MIN
  end

  def quality_can_increase?
    quality < QUALITY_MAX
  end

  # We have to do this weird -1 because for some reason the shelf life decreases
  # halfway through the method.
  def past_shelf_life_multiplier
     days_remaining - 1 < 0 ? 2 : 1
  end

  # All items that decrease need to double their decreasing effect if they are
  # past their shelf life.
  def daily_quality_decrease
    return unless quality_can_decrease?
    return @quality -= 2 * past_shelf_life_multiplier if conjured_item?
    @quality -= 1 * past_shelf_life_multiplier
  end

  def old_brie?
    name == 'Aged Brie' && days_remaining - 1 < 0
  end

  # All items that increase daily get +1.
  # Old brie gets an extra +1.
  # All tickets get additional age based bonuses.
  def daily_quality_increase
    quality_plus_one
    quality_plus_one if old_brie?
    return unless ticket_item?
    quality_plus_one if @days_remaining < 11
    quality_plus_one if @days_remaining < 6
  end

  def quality_plus_one
    @quality += 1 if @quality < QUALITY_MAX
  end

  def decrease_shelf_life
    @days_remaining -= 1
  end

  def zero_out_tickets
    return unless ticket_item?
    @quality -= @quality if @days_remaining < 0
  end
end
