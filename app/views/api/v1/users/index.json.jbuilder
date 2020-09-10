
json.array! @users do |user|
  json.id user.id
  json.mail user.mail
end