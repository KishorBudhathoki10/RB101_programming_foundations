munsters = {
  "Herman" => { "age" => 32, "gender" => "male" },
  "Lily" => { "age" => 30, "gender" => "female" },
  "Grandpa" => { "age" => 402, "gender" => "male" },
  "Eddie" => { "age" => 10, "gender" => "male" },
  "Marilyn" => { "age" => 23, "gender" => "female"}
}

total_age_of_males = 0

munsters.values.each do |v|
 total_age_of_males += v['age'] if v['gender'] == 'male'
end

p total_age_of_males
