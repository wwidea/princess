#!/bin/bash
cd test/princess
bundle install
bundle exec rake db:setup
bundle exec rake db:test:prepare

cd ../../
rake test