#!/bin/sh
flutter build ios --build-number $TRAVIS_BUILD_NUMBER --release --no-codesign
cd ios
bundle exec fastlane deployStaging