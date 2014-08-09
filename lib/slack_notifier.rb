require 'slack-notify'
require 'singleton'

class SlackNotifier
  include Singleton

  def initialize
    # from config?
    @client = SlackNotify::Client.new("donutworks", "G0QAYXA6uqygRTXjXCZ5Th2g")
  end

  def notify(msg)
    @client.notify(msg) unless Rails.env.development? || Rails.env.test?
  end
end