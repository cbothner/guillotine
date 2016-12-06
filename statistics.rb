x = File.open 'stats.txt', 'w'
sem = Semester.current_semester
x.puts "Statistics for Fundraiser #{sem.name}"
x.puts

dons = sem.slots.map(&:donations).flatten.reject {|d| d.pledger.underwriting }
total = dons.map(&:amount).inject(0,&:+).to_f
n = dons.count
x.puts "$%.2f in total with #{n} calls" % total
last_sem = Semester.last(2)[0]
last_tot = last_sem.slots.map(&:donations).flatten.reject {|d| d.pledger.underwriting }
  .map(&:amount).inject(0,&:+).to_f
ratio = ((total / last_tot) - 1) * 100
x.puts "#{ratio.abs.round 2}% #{ratio > 0 ? "increase" : "decrease"} compared to #{last_sem.name}"
x.puts

avg = total / n
x.puts "Average of $%.2f per call" % avg
x.puts

pledgers = dons.map(&:pledger).uniq
n_pled = pledgers.count
x.puts "#{n_pled} individual pledgers"

p_totals = pledgers.map do |pled|
  pled.donations
    .select { |d| d.slot.semester == sem }
    .map(&:amount)
    .reduce(0, &:+)
end
p_avg = p_totals.inject(0.0, &:+) / n_pled
x.puts "Average of $%.2f per pledger" % p_avg
x.puts

first_time_pled = pledgers.select do |p|
  p.donations.reject{|d| d.slot.semester == sem}.empty?
end
n_first_time = first_time_pled.count
ft_total = first_time_pled.map(&:donations).flatten.map(&:amount).inject(0,&:+)
x.puts "#{n_first_time} first-time pledgers, who contributed $%.2f" % ft_total
x.puts

Wday = {
  0 => "Sunday",
  1 => "Monday",
  2 => "Tuesday",
  3 => "Wednesday",
  4 => "Thursday",
  5 => "Friday",
  6 => "Saturday"
}
def day_and_month_from_yday(x)
  day = Time.local(x[0], x[1], x[2])
  "#{day.month}/#{day.day} (#{Wday[day.wday]})"
end
x.puts "Donations by Day:"
dons_by_day = dons.group_by do |d|
  c_a = d.created_at.getlocal
  [c_a.year, c_a.month, c_a.day]
end
dons_by_day.sort_by{|x| x[0]}.each do |d|
  count = d[1].count
  total = d[1].map(&:amount).inject(0,&:+)
  x.puts day_and_month_from_yday(d[0]) + " -- #{count} calls ($%.2f)" % total
end
x.puts

x.puts "Top Performing Shows:"
slot_totals = sem.slots.select{|s| s.length > 0}.map do |slot|
  show = slot.show
  slot_total = slot.donations.reject{|d| d.pledger.underwriting }.map(&:amount).inject(0,&:+)
  time = slot.length
  [show.get_name, slot_total, time]
end
slot_totals.sort_by!{|t| -t[1]}
slot_totals.first(20).each_with_index do |t,i|
  x.puts "%2d: $%.2f -- #{t[0]}" % [i+1, t[1]]
end
x.puts

x.puts "Top Performing Shows by Show Length:"
slot_tot_by_time = slot_totals.map do |t|
  [t[0], t[1]/t[2], t[2]]
end.sort_by{|t| -t[1]}
slot_tot_by_time.first(20).each_with_index do |t, i|
  x.puts "%2d: $%.2f -- #{t[0]} (#{t[2]} hrs)" % [i+1, t[1]]
end
