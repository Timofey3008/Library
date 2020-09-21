
json.code("200")
json.status("OK")
json.data do
  json.token @user.token
end