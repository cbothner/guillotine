class Pledger < ActiveRecord::Base
  attr_accessible :affiliation, :email, :first_name, :individual, :last_name, :local_address, :local_address2, :local_city, :local_phone, :local_state, :local_zip, :perm_address, :perm_address2, :perm_city, :perm_country, :perm_phone, :perm_state, :perm_zip

  validates :email, :last_name, :individual, :perm_address, :perm_city, :perm_country, :perm_phone, :presence => true
  validates :email, :format => { :with => /^[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,4}$/i, :message => "Must be a valid email address." }
  validates :affiliation, :inclusion => { :in => %w{staff alumni public}, :message => "Affiliation must be one of staff, alumni, or public" }
  with_options :if => :american? do |american|
    american.validates :perm_state, :presence => true, :length => { :is => 2 }
    american.validates :perm_zip, :presence => true, :numericality => { :only_integer => true }, :length => { :is => 5 }
  end
  with_options :if => :diff_local? do |local|
    local.validates :local_state, :local_city, :local_phone, :local_zip, :presence => true
    local.validates :local_state, :length => { :is => 2 }
    local.validates :local_zip, :numericality => { :only_integer => true }, :length => { :is => 5 }
  
  def american?
    :perm_country == "USA"
  end
  def diff_local?
    :local_address.blank?
  end
end
