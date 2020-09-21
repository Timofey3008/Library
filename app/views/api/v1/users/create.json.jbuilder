
json.code("201")
json.status("Created")
json.data do
  json.id @user.id
  json.mail @user.mail
  json.token @user.token
end