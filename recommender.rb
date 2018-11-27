class Recommender
	MAX_CONST = 5
	MIN_CONST = 1
	N_CONST = 50
	K_CONST = 2
	attr_reader :msd, :similarity, :concurrent_ratings_matrix, 
	:pearson_correlation, :knn_msd, :knn_pc, :overall_mean, :resnicks_msd, :resnicks_pc
	def initialize(user, matrix)
		@user_id = :"#{user}"
		@user_ratings = matrix[:"#{user}"]
		@matrix = matrix
		@num_users = matrix.keys.size
		@total_sample_size = matrix.keys.first.size
		@msd = {}
		@concurrent_ratings_matrix = {}
		@similarity = {}
		@pearson_correlation = {}
		@knn_msd = {}
		@knn_pc = {}
		@overall_mean = {}
		@resnicks_msd = {}
		@resnicks_pc = {}
	end

	def setup_recommendation
		other_users = @matrix.select { |k,v| k != @user_id}
		other_users.each do |name, ratings|
			set_concurrent_ratings_matrix(name, ratings)
			set_mean_squared_difference(name)
			set_pearson_correlation(name)
		end
		select_k_nearest_neighbors_msd
		select_k_nearest_neighbors_pearson
		set_overall_means
	end

	def set_concurrent_ratings_matrix(name, ratings)
		@concurrent_ratings_matrix[name] = @user_ratings.zip(ratings)
		.select { |u1, u2| u1 > 0 && u2 > 0 }
	end

	def set_mean_squared_difference(name)
		@msd[name] = (calculate_squared_difference(
			@concurrent_ratings_matrix[name]) / 
				@concurrent_ratings_matrix[name].size.to_f)
				.round(2)
		calculate_similarity(name)
	end

	def calculate_squared_difference(matrix)
		matrix
			.map { |m| (m[0] - m[1]) ** 2 }
			.inject(0) { |sum, m| sum + m }
	end

	def calculate_similarity(name)
		@similarity[name] = (1 - (@msd[name] / (MAX_CONST - MIN_CONST)**2)).round(2)
	end

	def get_mean_rating(user)
		(user.inject(0) { |sum, element| sum + element } / user.size.to_f).round(2)
	end

	def set_pearson_correlation(name)
		user1 = @concurrent_ratings_matrix[name].map { |row| row[0] }
		user1_mean = get_mean_rating(user1)
		user2 = @concurrent_ratings_matrix[name].map { |row| row[1] }
		user2_mean = get_mean_rating(user2)
		numerator = 0.0
		numerator = 0.0

		denom_user1 = (user1.inject(0) { |sum,element| sum + ((element - user1_mean)**2).round(2) }).round(2)
		denom_user2 = (user2.inject(0) { |sum,element| sum + ((element - user2_mean)**2).round(2) }).round(2)

		denominator = 
			Math.sqrt((denom_user1 * denom_user2).round(2)).round(2)

		(0..user1.size-1).each do |i|
			numerator += ((user1[i] - user1_mean) * (user2[i] - user2_mean))
		end
		numerator = numerator.round(2)

		if denominator == 0
			@pearson_correlation[name] = 0
		else
			@pearson_correlation[name] = 
							(numerator.round(2) / 
								denominator.round(2)).round(2)
		end
	end

	def select_k_nearest_neighbors_msd
		ordered = @similarity.sort_by { |k,v| v }.reverse
		neighborhood = {}
		(0..K_CONST-1).each do |i|
			neighborhood[ordered[i][0]] = ordered[i][1]
		end
		@knn_msd = neighborhood
	end

	def select_k_nearest_neighbors_pearson
		ordered = @pearson_correlation.sort_by { |k,v| v }.reverse
		neighborhood = {}
		(0..K_CONST-1).each do |i|
			neighborhood[ordered[i][0]] = ordered[i][1]
		end
		@knn_pc = neighborhood
	end

	def set_overall_means
		@matrix.each_key { |k| set_user_overall_mean(k) }
	end

	def set_user_overall_mean(user)
		user_ratings = @matrix[user].select { |rating| rating > -1 }
		size = user_ratings.count { |rating| rating > -1 }.to_f
		@overall_mean[user] = (user_ratings.inject(0) { |sum, element| sum + element } / size).round(2)
	end

	def resnicks_predicted_rating_msd(item_index)
		numerator = 0
		denominator = 0
		mean1 = @overall_mean[@user_id]
		@knn_msd.each do |user, pc|
			w = @similarity[user]
			ratings = @matrix[user]
			mean2 = @overall_mean[user]
			numerator += w * (ratings[item_index] - mean2)
			numerator = numerator.round(2)
			denominator += w.abs
		end
		@resnicks_msd[item_index] = (mean1 + (numerator / denominator).round(2)).round(2)
	end

	def resnicks_predicted_rating_pc(item_index)
		numerator = 0
		denominator = 0
		mean1 = @overall_mean[@user_id]
		@knn_pc.each do |user, pc|
			w = @pearson_correlation[user]
			ratings = @matrix[user]
			mean2 = @overall_mean[user]
			numerator += w * (ratings[item_index] - mean2)
			numerator = numerator.round(2)
			denominator += w.abs
		end
		@resnicks_pc[item_index] = (mean1 + (numerator / denominator).round(2)).round(2)
	end
end


matrix = {
	:user1 => [1, 4, 4, -1, 3, -1],
	:user2 => [1, 5, -1, 2, 4, 5],
	:user3 => [-1, 3, 5, -1, 5, -1],
	:user4 => [3, -1, 3, -1, 4, 1],
	:user5 => [1, 1, -1, 5, 4, 3],
	:user6 => [5, -1, -1, 1, -1, -1]
}

user5Rec = Recommender.new('user5', matrix)
user5Rec.setup_recommendation
user5Rec.select_k_nearest_neighbors_msd
user5Rec.select_k_nearest_neighbors_pearson
u5i3_msd = user5Rec.resnicks_predicted_rating_msd(2)
u5i3_pc = user5Rec.resnicks_predicted_rating_pc(2)

puts "\n\n"
puts "Resnick's MSD: #{u5i3_msd}"
puts "Resnick's PC : #{u5i3_pc}"

p "Means: #{user5Rec.overall_mean}"
p "KMSD : #{user5Rec.knn_msd}"
p "KPC  : #{user5Rec.knn_pc}"
p "MSD  : #{user5Rec.similarity}"
p "PC   : #{user5Rec.pearson_correlation}"