#!/usr/bin/tclsh

lappend auto_path [file join [pwd] ..]

#package require selenium::firefox
#set driver [::selenium::FirefoxDriver new]

package require selenium::chrome
set driver [::selenium::ChromeDriver new -browser_args --headless]

#package require selenium::chromium
#set driver [::selenium::ChromiumDriver new]

#package require selenium::opera
#set driver [::selenium::OperaDriver new -binary operadriver -browser_binary /snap/bin/opera]

#package require selenium::phantomjs
#set driver [::selenium::PhantomJSdriver new]

# ok
#package require selenium
#package require selenium::utils::port
#set port [::selenium::utils::port::get_free_port]
#exec java -cp htmlunit-driver.jar:selenium-server-v3.jar --port $port &
#set driver [::selenium::WebDriver new http://127.0.0.1:$port/wd/hub $::selenium::DesiredCapabilities(HTMLUNITWITHJS)]

# ok
#package require selenium
#package require selenium::utils::port
#set port [::selenium::utils::port::get_free_port]
#exec java -jar selenium-server-v4.jar standalone --port $port &
#set capabilities {browserName firefox}
#set driver [::selenium::WebDriver new http://127.0.0.1:$port/wd/hub $capabilities]

puts driver=$driver

$driver get http://www.google.com

set input_q [$driver find_element_by_name q]
puts "input q: $input_q"

$driver send_keys $input_q "hello world"
$driver send_keys $input_q $::selenium::Key(RETURN)

after 2000

puts "title: [$driver title]"
puts "current url: [$driver current_url]"

$driver back

after 2000

puts "title: [$driver title]"
puts "current url: [$driver current_url]"

# Example of execute_javascript method
set element [$driver execute_javascript {return document.body} -returns_element]
puts "extracted the body element: $element"

after 2000

puts "Finishing the program..."
$driver quit
