# By using the symbol ':user', we get Factory Girl to simulate the User model.
Factory.define :user do |user|
  user.first_name            "Joe"
  user.last_name             "Blow" 
  user.email                 "jblow@test.com"
  user.password              "foobar"
  user.city            		 "Detroit"
  user.gender            	 "Male"
  user.birth_date            "1967-04-23"
end
