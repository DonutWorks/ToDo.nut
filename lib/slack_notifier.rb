require 'slack-notify'
require 'singleton'

class SlackNotifier
  include Singleton

  def notify(msg)
    client.notify(msg) unless Rails.env.development? or Rails.env.test?
  end

private
  def client
    @client || SlackNotify::Client.new("donutworks", "G0QAYXA6uqygRTXjXCZ5Th2g")
  end
end
