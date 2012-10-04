#!/bin/bash
bundle install

cd test/princess
bundle exec rake db:setup
bundle exec rake db:test:prepare

cd ../../
rake test