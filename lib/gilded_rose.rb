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
    # possible entries = [ 'legendary', 'aged', 'ticket', 'conjured' ]
    @attributes = attributes.to_set
  end

  def tick
    puts "Processing item: #{@name}"

    handleStandardItem if @attributes.empty?
    handleAged if @attributes.include? 'aged'
    handleLegendary if @attributes.include? 'legendary'
    handleTicket if @attributes.include? 'ticket'
    handleConjured if @attributes.include? 'conjured'

    puts "Item processed: #{self.inspect}"
  end

  private

  def handleStandardItem
    handleStandardDegredation
  end

  def handleAged
    # aged items cannot exceed quality of 50
    if @quality < 50
      @quality = @quality + 1
    end

    @days_remaining = @days_remaining - 1
    if @days_remaining < 0
      if @quality < 50
        @quality = @quality + 1
      end
    end
  end

  def handleLegendary
    # No Op - legendary items remain unchanged
  end

  def handleTicket
    if @quality < 50
      @quality = @quality + 1

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

    @days_remaining = @days_remaining - 1

    if @days_remaining < 0
      @quality = 0
      return
    end
  end

  # Identical behavior to standard item with exeption of degradation rate
  # Utilizes abstracted 'handleStandardDegradation' method
  def handleConjured
    handleStandardDegredation(2)
  end

  # handles standard degrading item behavior
  # takes param 'decrementValue' to affect rate of degradation
  def handleStandardDegredation(decrementValue = 1)
    if @quality > 0
      @quality = @quality - decrementValue
    end

    @days_remaining = @days_remaining - 1
    if @days_remaining < 0
      if @quality > 0
        @quality = @quality - decrementValue
      end
    end
  end
end
