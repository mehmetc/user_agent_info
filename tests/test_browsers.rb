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
SAFARI_OSX_HEADER = 'Mozilla/5.0 (Macintosh; U; PPC Mac OS X; en) AppleWebKit/125.2 (KHTML, like Gecko) Safari/85.8'
CHROME_OSX_HEADER  ='Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10_5_8; en-US) AppleWebKit/532.3 (KHTML, like Gecko) Chrome/4.0.223.11 Safari/532.3'
OPERA_OSX_HEADER   ='Opera/9.80 (Macintosh; Intel Mac OS X; U; en) Presto/2.2.15 Version/10.00'
IE_80_WIN_HEADER   ='Mozilla/4.0 (compatible; MSIE 8.0; Windows NT 5.1; Trident/4.0)'
IE_70_WIN_HEADER   ='Mozilla/4.0 (compatible; MSIE 7.0; Windows NT 5.1; .NET CLR 1.1.4322; .NET CLR 2.0.50727; .NET CLR 3.0.04506.648; .NET CLR 3.5.21022; .NET CLR 3.0.4506.2152; .NET CLR 3.5.30729)'
FIREFOX_WIN_HEADER ='Mozilla/5.0 (Windows; U; Windows NT 5.1; en-GB; rv:1.9.0.14) Gecko/2009082707 Firefox/3.0.14 (.NET CLR 3.5.30729)'
OLD_FIREFOX_LINUX_HEADER = 'Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.8.1.14) Gecko/20080404 Firefox/2.0.0.14'
SPINNER_ROBOT = 'Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.0.19; aggregator:Spinn3r (Spinn3r 3.1); http://spinn3r.com/robot) Gecko/2010040121 Firefox/3.0.19'

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

    context "Safari OSX" do
      setup do
        @request = Request.new(SAFARI_OSX_HEADER)
        @browser_error_message = "This is #{@request.user_agent_info['name_display']} #{@request.user_agent_info['version']}"
      end

      should 'not be IE' do
        assert(@request.user_agent_info.isIE? == false, @browser_error_message)
      end

      should 'extract correct browser_info' do
        browser_info = @request.user_agent_info

        assert_equal(SAFARI_OSX_HEADER,    browser_info['header'],        'wrong header')
        assert_equal('Macintosh',          browser_info['platform'],      'wrong platform')
        assert_equal('Safari',             browser_info['name'],          'wrong name')
        assert_equal(nil,                  browser_info['name_display'],  'wrong name_display')
        assert_equal('PPC Mac OS X',       browser_info['cpuos'],         'wrong cpuos')
        assert_equal('en',                 browser_info['language'],      'wrong language')
        assert_equal(85.8,                 browser_info['version'],       'wrong version')
        assert_equal('AppleWebKit/125.2',  browser_info['engine'],        'wrong engine')
      end
    end

    context "Chrome OSX" do
      setup do
        @request = Request.new(CHROME_OSX_HEADER)
        @browser_error_message = "This is #{@request.user_agent_info['name_display']} #{@request.user_agent_info['version']}"
      end

      should 'not be IE' do
        assert(@request.user_agent_info.isIE? == false, @browser_error_message)
      end

      should 'extract correct browser_info' do
        browser_info = @request.user_agent_info

        assert_equal(CHROME_OSX_HEADER,        browser_info['header'],        'wrong header')
        assert_equal('Macintosh',              browser_info['platform'],      'wrong platform')
        assert_equal('Chrome',                 browser_info['name'],          'wrong name')
        assert_equal('Google Chrome',          browser_info['name_display'],  'wrong name_display')
        assert_equal('Intel Mac OS X 10_5_8',  browser_info['cpuos'],         'wrong cpuos')
        assert_equal('en-US',                  browser_info['language'],      'wrong language')
        assert_equal(4.0,                      browser_info['version'],       'wrong version')
        assert_equal('AppleWebKit/532.3',      browser_info['engine'],        'wrong engine')
      end
    end

    context "Spinner robot" do
      setup do
        @request = Request.new(SPINNER_ROBOT)
        @browser_error_message = "This is #{@request.user_agent_info['name_display']} #{@request.user_agent_info['version']}"
      end

      should 'not be IE' do
        assert(@request.user_agent_info.isIE? == false, @browser_error_message)
      end

      should 'extract correct browser_info' do
        browser_info = @request.user_agent_info

        assert_equal(SPINNER_ROBOT,       browser_info['header'],        'wrong header')
        assert_equal('X11',               browser_info['platform'],      'wrong platform')
        assert_equal('Firefox',           browser_info['name'],          'wrong name')
        assert_equal('Mozilla Firefox',   browser_info['name_display'],  'wrong name_display')
        assert_equal('Linux x86_64',      browser_info['cpuos'],         'wrong cpuos')
        assert_equal('en-US',             browser_info['language'],      'wrong language')
        assert_equal(3.0,                 browser_info['version'],       'wrong version')
        assert_equal('Gecko/2010040121',  browser_info['engine'],        'wrong engine')
      end
    end

    context "Old Firefox on Linux" do
      setup do
        @request = Request.new(OLD_FIREFOX_LINUX_HEADER)
        @browser_error_message = "This is #{@request.user_agent_info['name_display']} #{@request.user_agent_info['version']}"
      end

      should 'not be IE' do
        assert(@request.user_agent_info.isIE? == false, @browser_error_message)
      end

      should 'extract correct browser_info' do
        browser_info = @request.user_agent_info

        assert_equal(OLD_FIREFOX_LINUX_HEADER, browser_info['header'],       'wrong header')
        assert_equal('X11',                    browser_info['platform'],     'wrong platform')
        assert_equal('Firefox',                browser_info['name'],         'wrong name')
        assert_equal('Mozilla Firefox',        browser_info['name_display'], 'wrong name_display')
        assert_equal('Linux i686 (x86_64)',    browser_info['cpuos'],        'wrong cpuos')
        assert_equal('en-US',                  browser_info['language'],     'wrong language')
        assert_equal(2.0,                      browser_info['version'],      'wrong version')
        assert_equal('Gecko/20080404',         browser_info['engine'],       'wrong engine')
      end
    end
  end
end
