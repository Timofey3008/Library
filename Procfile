web: bundle exec puma -t 5:5 -p ${PORT:-3000} -e ${RACK_ENV:-development}
resque: QUEUE=* bundle exec rake resque:work
scheduler: bundle exec rake resque:scheduler