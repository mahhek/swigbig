class BarDeal < ActiveRecord::Base
  belongs_to :bar
  belongs_to :deal

  validates :bar_id, :presence => true
  validates :deal_id, :presence => true
  validates :deal_id, :uniqueness => {:scope => :bar_id}

  def self.reset_actived_deal
    Time.zone = "EST"
    current_time = Time.zone.now
    time_to_reset = Time.zone.parse("06:00")
    if current_time >= time_to_reset
      day_number = current_time.strftime("%u").to_i - 1
      Deal.where(day_of_week: day_number).each do |deal|
        deal.bar_deals.each do |bar_deal|
          bar_deal.is_active = false
          bar_deal.save :validate => false
        end
      end
    end
  end
end
