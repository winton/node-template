#!/bin/bash

cd client
bundle install
bundle exec stasis -p '../public' -d