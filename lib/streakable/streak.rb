class Streak
  attr_reader :instance, :association
  def initialize(instance, association)
    @instance = instance
    @association = association
  end

  def length
    determine_consecutive_days
  end

  private
    def days
      @days ||= instance.send(association).order("created_at DESC").pluck(:created_at).map(&:to_date).uniq
    end

    def determine_consecutive_days
      streak = first_day_in_collection_is_today? ? 1 : 0
      days.each_with_index do |day, index|
        break unless first_day_in_collection_is_today?
        if days[index+1] == day.yesterday
          streak += 1
        else
          break
        end
      end
      streak
    end

    def first_day_in_collection_is_today?
      days.first == Date.current
    end
end