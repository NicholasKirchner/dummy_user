get '/' do
  redirect '/secretpage' if session[:user]
  erb :index
end

post '/login' do
  user = User.authenticate(params[:email],params[:password])
  session[:user] = user
  redirect '/secretpage'
end

get '/signup' do
  @error = session.delete(:error) if session[:error]
  erb :signup
end

post '/create' do
  user = User.new(params)
  if user.valid? 
    user.save
    session[:user] = user
    redirect '/secretpage'
  else
    session[:error] = "Your sign up failed. Password must be between five and twenty characters. Try again."
    redirect '/signup'
  end
  
end

get '/logout' do
  session[:user] = nil
  redirect '/'
end

get '/secretpage' do
  @user = session[:user]
  if @user 
    erb :secretpage
  else
    redirect '/'
  end
end

