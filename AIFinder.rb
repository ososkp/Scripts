hy = 0.9852
total = 3

def get_I(total, hy)
	size_and_h = {}
	block = 0
	puts "How many categories?\n"
	num = gets.to_i
	(1..num).each_with_index do |i|
		puts "Sample size for category #{i}"
		size = gets.to_i
		size_and_h[size] = get_H(size.to_f)
		block += (size / total) * size_and_h[size]
	end
	result = hy - block

	puts "Result:\nI(Y;X) = #{result}"
end

def get_H(total)
	puts "Number of positives:\n"
	pos = gets.to_f
	
	neg = total - pos

	pos_prop = pos/total
	neg_prop = neg/total

		if pos == 0 || pos == total
			value = 0
		else
			value = -(pos_prop * Math.log2(pos_prop) + neg_prop * Math.log2(neg_prop))
		end

	puts "H(Y|X=x) = #{value}"
	value
end

puts "Enter 0 for H(Y|X=x), 1 for I(Y;X):\n"
num = gets.to_f

#puts "Total sample size:\n"
#total = gets.to_f

if num == 0 
	value = get_H(total.to_f)
	else
	value = get_I(total.to_f, hy)
end