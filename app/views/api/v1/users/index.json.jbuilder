
json.code("200")
json.status("OK")
json.data do
  json.array! @users do |user|
    json.id user.id
    json.mail user.mail
  end
end