json.data do
  json.user do
    json.email @user.email
    json.authentication_token @user.authentication_token
  end
end