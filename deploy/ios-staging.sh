#!/bin/sh
flutter build ios  --release --no-codesign
cd ios
bundle exec fastlane deployStaging
