# HomeControl

A universal app for interacting with your MQTT-powered home devices.

## Installation

* Install Xcode 7.3.1
* Install the mosquitto MQTT broker: `$ brew install mosquitto`
* Start mosquitto: `$ mosquitto`
  * For monitoring messages on all topics, run: `mosquitto_sub -h localhost -t '#' -v`
* Open `HomeControl.xcworkspace`
* Start hacking!

This project uses Cocoapods, but they are always checked into Git to ensure reproducable builds.

## License

MIT, see `LICENSE.txt`