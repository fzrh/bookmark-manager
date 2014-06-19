get '/users/new' do
	# note that the view is in views/users/new.erb
	# we need the quotes because otherwise
	# ruby would divide the symbol :users by the
	# variable new (which makes no sense)
	@user = User.new
	erb :"users/new"
end

post '/users' do
	@user = User.new(:email => params[:email], :password => params[:password], :password_confirmation => params[:password_confirmation])
	if @user.save
		session[:user_id] = @user.id
		redirect to('/')
	else
		flash[:errors] = @user.errors.full_messages
		erb :"users/new"
	end
end

get '/sessions/forgot_password' do
	erb :"sessions/forgot_password"
end

post '/recovery' do
	if	email = params[:email]
		user = User.first(:email => email)
		# avoid having to memorise ascii codes
		user.password_token = (1..64).map{('A'..'Z').to_a.sample}.join
		user.password_token_timestamp = Time.now
		user.save
	else
		flash[:errors] = @user.errors.full_messages
		erb :"users/new"
	end		
end

get '/users/reset_password/:token' do
	user = User.first(:password_token => token)
end

