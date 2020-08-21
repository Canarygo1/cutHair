#!/bin/sh
travis_wait 30 flutter build ios  --release --no-codesign
cd ios
bundle exec fastlane deployStaging
