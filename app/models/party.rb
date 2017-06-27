#
# Table Schema
# ------------
# id            - int(11)      - default NULL
# host_name     - varchar(255) - default NULL
# host_email    - varchar(255) - default NULL
# numgsts       - int(11)      - default NULL
# guest_names   - text, array: true, default: []
# venue         - varchar(255) - default NULL
# location      - varchar(255) - default NULL
# theme         - varchar(255) - default NULL
# when          - datetime     - default NULL
# when_its_over - datetime     - default NULL
# descript      - text         - default NULL
#
class Party < ApplicationRecord

  validate :validations

  def validations
    if host_name.length>255 || host_email.length>255 || venue.length>255 || location.size>255 || theme.size>255
      errors.add(:base, "Input was too long.")
    end

    # ruby doesn't like us using when as column name for some reason
    errors.add(:base, "Incorrect party time.") if self[:when]>when_its_over
    numgsts = 0 if numgsts.nil?

    errors.add(:location, "Where is the party?") if venue.length > 0 && location.length < 0
    errors.add(:guest_names, "Missing guest name") if guest_names.split(',').size != numgsts
  end

  def after_save
    # clean "Harry S. Truman" guest name to "Harry S._Truman"
    # clean "Roger      Rabbit" guest name to "Roger Rabbit"
    gnames = []
    guest_names.split(',').each do |g|
      g.squeeze!(' ')
      names = g.split(' ')
      gnames << "#{names[0]} #{names[1..-1].join('_')}"
    end
    guest_names = gnames
    save!
  end
end
