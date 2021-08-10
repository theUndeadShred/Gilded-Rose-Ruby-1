# All items have a days_remaining value which denotes the number of days we have to sell the item

# All items have a quality value which denotes how valuable the item is

# At the end of each day our system lowers both values for every item

# Once the sell by date has passed, Quality degrades twice as fast

# The Quality of an item is never negative

# "Aged" items actually increases in Quality the older they get

# The Quality of an item is never more than 50, unless "Legendary"

# "Legendary" items never have to be sold or decrease in Quality. They never change.

# "Backstage passes", like "Aged" items, increases in Quality as it's Days Remaining value approaches zero; Quality increases by 2 when there are 10 days or less and by 3 when there are 5 days or less but Quality drops to 0 after the concert

# Our Task
# We have recently signed a supplier of conjured items. This requires an update to our system:
# "Conjured" items degrade in Quality twice as fast as normal items

class GildedRose
  attr_reader :name, :days_remaining, :quality, :attributes

  def initialize(name:, days_remaining:, quality:, attributes:)
    @name = name
    @days_remaining = days_remaining
    @quality = quality

    # an array of distinctions that change how time affects quality
    @attributes = attributes 
  end

  def tick
    if !@attributes.include? 'aged' and @name != "Backstage passes to a TAFKAL80ETC concert"
      if @quality > 0
        if !@attributes.include? 'legendary'
          @quality = @quality - 1
        end
      end
    else
      if @quality < 50
        @quality = @quality + 1
        if @name == "Backstage passes to a TAFKAL80ETC concert"
          if @days_remaining < 11
            if @quality < 50
              @quality = @quality + 1
            end
          end
          if @days_remaining < 6
            if @quality < 50
              @quality = @quality + 1
            end
          end
        end
      end
    end
    if !@attributes.include? 'legendary'
      @days_remaining = @days_remaining - 1
    end
    if @days_remaining < 0
      if !@attributes.include? 'aged'
        if @name != "Backstage passes to a TAFKAL80ETC concert"
          if @quality > 0
            if !@attributes.include? 'legendary'
              @quality = @quality - 1
            end
          end
        else
          @quality = @quality - @quality
        end
      else
        if @quality < 50
          @quality = @quality + 1
        end
      end
    end
  end
end
