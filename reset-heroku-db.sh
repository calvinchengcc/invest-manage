#!/usr/bin/env sh
set -x
heroku pg:reset DATABASE_URL --confirm investmanage && heroku run rake db:migrate db:seed
