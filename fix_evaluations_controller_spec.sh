#!/bin/bash

# Replace 'sign_in :user, X' with 'sign_in X'
sed -i 's/sign_in :user, /sign_in /g' spec/controllers/evaluations_controller_spec.rb

# Remove individual @request.env['devise.mapping'] lines since we added it globally
grep -n "@request.env\\['devise.mapping'\\] = Devise.mappings\\[:user\\]" spec/controllers/evaluations_controller_spec.rb | awk -F: '{print $1}' | sort -nr | while read line; do
  sed -i "${line}d" spec/controllers/evaluations_controller_spec.rb
done
