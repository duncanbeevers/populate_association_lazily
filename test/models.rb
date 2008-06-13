class User < ActiveRecord::Base
  has_one :wristband
  validates_presence_of :wristband
end

class Wristband < ActiveRecord::Base
  belongs_to :user
  validates_presence_of :color
end

class Admiration < ActiveRecord::Base
end
