# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

#PLEDGER
cameron = Pledger.create(
 individual: true,
 email: "cbothner@umich.edu",
 affiliation: "Staff",
 local_phone: "",
 local_address: "1004 S. Forest Ave",
 local_address2: "Apt. B2",
 local_city: "Ann Arbor",
 local_state: "MI",
 local_zip: "48104",
 perm_phone: "(734) 395-5779",
 perm_address: "3515 Sturbridge Ct",
 perm_address2: "",
 perm_city: "Ann Arbor",
 perm_state: "MI",
 perm_zip: "48105",
 perm_country: "USA",
 name: "Cameron Bothner"
)

#SHOW
ceci = Show.create(
  name: "Ceci n'est pas Freeform",
  dj: "Cameron"
)
freeform = Show.create(
  name: "Freeform",
  dj: "Cameron"
)

#SLOTS
oldslot = Slot.create(
  semester: 1,
  weekday: 2,
  start: "12:00",
  end: "15:00"
)
freeform.slots<<oldslot

nowslot = Slot.create(
  semester: 2,
  weekday: 3,
  start: "15:00",
  end: "18:00"
)
ceci.slots<<nowslot

#DONATIONS
paiddon = Donation.create(
  amount: 100.00,
  payment_method: "Check",
  pledge_form_sent: true,
  payment_received: true,
  gpo_sent: true,
  gpo_processed: true,
  phone_operator: "Ben Yee"
)
cameron.donations<<paiddon
oldslot.donations<<paiddon

unpaid = Donation.create(
  amount: 200.00,
  payment_method: "Check",
  pledge_form_sent: true,
  payment_received: false,
  gpo_sent: false,
  gpo_processed: false,
  phone_operator: "Rob Goldey"
)
cameron.donations<<unpaid
nowslot.donations<<unpaid

#ITEMS
havesome = Item.create(
  name: "Boombox T-Shirt",
  taxable_value: 10,
  cost: 30,
  stock: 100,
  backorderable: false,
  shape: "shirt",
  note: ""
)

backorderable = Item.create(
  name: "Pint Glass",
  taxable_value: 7,
  cost: 20,
  stock: 0,
  backorderable: true,
  shape: "box"
)

allgone = Item.create(
  name: "Box Set",
  taxable_value: 30,
  cost: 88.30,
  stock: 0,
  backorderable: false,
  shape: "box"
)

#REWARDS
sent = Reward.create(
  premia_sent: true,
  taxed: true,
  comment: "Send it there!"
)
cameron.rewards<<sent
allgone.rewards<<sent

unsent = Reward.create(
  premia_sent: false,
  taxed: false,
  comment: "Be quick about it!"
)
cameron.rewards<<unsent
havesome.rewards<<unsent
