$LOAD_PATH << '../lib'
require 'rubygems'
require 'test/unit'
require 'shoulda'

require 'action_controller'
require 'user_agent_info'


class Request
  attr_accessor :headers
  
  def initialize(header) 
    @headers = {'HTTP_USER_AGENT' => header}
  end
    
  def user_agent_info
    UserAgentInfo::UserAgent.new(self)       
  end
  
  def headers
    @headers
  end
  
end

FIREFOX_OSX_HEADER ='Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10.5; en-US; rv:1.9.1.4) Gecko/20091016 Firefox/3.5.4'
CHROME_OSX_HEADER  ='Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10_5_8; en-US) AppleWebKit/532.3 (KHTML, like Gecko) Chrome/4.0.223.11 Safari/532.3'
OPERA_OSX_HEADER   ='Opera/9.80 (Macintosh; Intel Mac OS X; U; en) Presto/2.2.15 Version/10.00'
IE_80_WIN_HEADER   ='Mozilla/4.0 (compatible; MSIE 8.0; Windows NT 5.1; Trident/4.0)'
IE_70_WIN_HEADER   ='Mozilla/4.0 (compatible; MSIE 7.0; Windows NT 5.1; .NET CLR 1.1.4322; .NET CLR 2.0.50727; .NET CLR 3.0.04506.648; .NET CLR 3.5.21022; .NET CLR 3.0.4506.2152; .NET CLR 3.5.30729)'
FIREFOX_WIN_HEADER ='Mozilla/5.0 (Windows; U; Windows NT 5.1; en-GB; rv:1.9.0.14) Gecko/2009082707 Firefox/3.0.14 (.NET CLR 3.5.30729)'

class TestBrowsers < Test::Unit::TestCase

  context "All browsers user agent info" do
    context "MS Internet Explorer" do
      setup do
        @request = Request.new(IE_80_WIN_HEADER)
        @browser = "This is #{@request.user_agent_info['name_display']} #{@request.user_agent_info['version']}"
      end
      
      should 'be Internet Explorer 8.0' do
        assert(@request.user_agent_info.isIE?('8.0'), @browser) 
      end

      should 'be Internet Explorer 6.0 or better' do
        assert(@request.user_agent_info.isIE_or_better?('6.0'), @browser) 
      end            
    end
  end
end