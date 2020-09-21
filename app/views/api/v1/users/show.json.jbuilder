
json.code("200")
json.status("OK")
json.data do
  json.id @user.id
  json.mail @user.mail
end