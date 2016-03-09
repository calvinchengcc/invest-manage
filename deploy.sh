#!/usr/bin/env sh
set -x
git push --force heroku `git subtree split --prefix project-final HEAD`:master
