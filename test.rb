require "slack-notify"

client = SlackNotify::Client.new("donutworks", "G0QAYXA6uqygRTXjXCZ5Th2g")

client.test

client.notify("Hello There!")
