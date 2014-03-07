require 'mechanize'
module Gateways
  class Xpiron
    def initialize(username, password)
      @username = username
      @password = password
    end

    def book(start_time)
      agent.get('https://www.xpiron.com/schedule/ucsf') do |login_page|
        home = login_page.form_with(name: 'login') do |f|
          f.pEmailAddr = @username
          f.pPassword = @password
        end.click_button

        courts = agent.click(home.link_with(text: /MISSION BAY COURTS/))
        binding.pry
        court = agent.click(courts.link_with(text: start_time.strftime("_%m/%d_")))
        popup = agent.click(court.link_with(text: /#{start_time.strftime("%-l:%M%P")}/))
        agent.click(popup.link_with(id: "s1"))
      end
    end

    def agent
      @agent ||= Mechanize.new do |agent|
                   agent.user_agent_alias = 'Mac Safari'
                 end
    end
  end
end
