# HomeControl

HomeControl is a "universal remote" for interacting with your MQTT-powered smart home.
Its dashboard can be customized with switches, indicators and buttons, featuring two-way communication with MQTT.
This means that their states will live update whenever an external user or system changes something.

![](https://raw.githubusercontent.com/mbernson/HomeControl.iOS/feature/screenshot/Design/Screen%20Shot%202016-12-20%20at%2020.10.56.png)

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
