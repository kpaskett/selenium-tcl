#
#
#

namespace eval ::test {
    namespace export webConnect webDisconnect

    variable javaExecutable
    variable htmlunitLauncher
    variable seleniumLauncher
    variable selenium4Launcher
    variable seleniumBrowser
    variable seleniumDriverPort
    variable seleniumDriverPid
    variable webDriverChecks
    variable webDriverCount
    variable webDriver

    variable seleniumBrowser "CHROME"

    set javaExecutable [expr {[info exists env(JAVA_HOME)] ? [file join $env(JAVA_HOME) bin java] : "java"}]
    set seleniumPath [expr {[info exists env(SELENIUM)] ? $env(SELENIUM) : "/usr/local/lib/selenium"}]
    if {![info exists htmlunitLauncher]} {
        if {$tcl_platform(platform) eq "windows"} {
            set htmlunitLauncher "-cp $seleniumPath/htmlunit-driver-2.44.0-jar-with-dependencies.jar\\;$seleniumPath/selenium-server-standalone-3.141.59.jar org.openqa.grid.selenium.GridLauncherV3"
        } else {
            set htmlunitLauncher "-cp $seleniumPath/htmlunit-driver-2.44.0-jar-with-dependencies.jar:$seleniumPath/selenium-server-standalone-3.141.59.jar org.openqa.grid.selenium.GridLauncherV3"
        }        
    }
    if {![info exists seleniumLauncher]} {
        set seleniumLauncher "-jar $seleniumPath/selenium-server-standalone-3.141.59.jar"
    }
    if {![info exists selenium4Launcher]} {
        set selenium4Launcher "-jar $seleniumPath/selenium-server-4.0.0-alpha-6.jar standalone"
    }

    array set webDriverChecks [list \
        chromeDriver    "exec chromedriver --version" \
        geckoDriver     "exec geckodriver --version" \
        operaDriver     "exec operadriver --version" \
        ieDriver        "exec iedriverserver --version" \
        phantomjsDriver "exec phantomjs --version" \
        htmlunitDriver  "exec $javaExecutable $htmlunitLauncher --version" \
        seleniumDriver  "exec $javaExecutable $seleniumLauncher --version" \
        selenium4Driver "exec $javaExecutable $selenium4Launcher --version"]

    set webDriverCount 0

    proc seleniumLaunch {launcher {params {}}} {
        package require selenium::utils::port
        set ::test::seleniumPort [::selenium::utils::port::get_free_port]
        set ::test::seleniumPid [exec $::test::javaExecutable {*}$launcher $::test::seleniumPort {*}$params &]
        if {![::selenium::utils::port::wait_until_connectable $::test::seleniumPort]} {
            error "Can not connect to the Selenium"
        }
    }
    
    proc seleniumKill {} {
         package require http
         package require selenium::utils::process
         ::http::geturl "http://127.0.0.1:$::test::seleniumPort/shutdown"
         ::selenium::utils::port::wait_until_connectable $::test::seleniumPort 10
         ::selenium::utils::process::kill $::test::seleniumPid
         unset ::test::seleniumPort
         unset ::test::seleniumPid
    }
}
    
proc ::test::chromeDriver {{params {-browser_args {-headless -test-type}}}} {
    package require selenium::chrome
    set driver [::selenium::ChromeDriver new {*}$params]
    return $driver
}

proc ::test::geckoDriver {{params {-use_geckodriver 1}}} {
    package require selenium::firefox
    set driver [::selenium::FirefoxDriver new {*}$params]
#   testConstraint handlesAlerts 1
    testConstraint cssSelectorsEnabled 1
    return $driver
}

proc ::test::operaDriver {{params {}}} {
    package require selenium::opera
    set driver [::selenium::OperaDriver new {*}$params]
    return $driver
}

proc ::test::phantomjsDriver {{params {}}} {
    package require selenium::phantomjs
    set driver [::selenium::PhantomJSdriver new {*}$params]
    return $driver
}

proc ::test::htmlunitDriver {{params {}}} {
    package require selenium
    ::test::seleniumLaunch "$::test::htmlunitLauncher -port" $params
    set driver [::selenium::WebDriver new http://127.0.0.1:$::test::seleniumPort/wd/hub $::selenium::DesiredCapabilities(HTMLUNITWITHJS)]
    return $driver
}

proc ::test::seleniumDriver {{params {}}} {
    package require selenium
    ::test::seleniumLaunch "$::test::seleniumLauncher -port" $params
    set driver [::selenium::WebDriver new http://127.0.0.1:$::test::seleniumPort/wd/hub $::selenium::DesiredCapabilities($::test::seleniumBrowser)]
    testConstraint handlesAlerts 1
    testConstraint cssSelectorsEnabled 1
    testConstraint javascriptEnabled 1
    return $driver
}

proc ::test::selenium4Driver {{params {}}} {
    package require selenium
    ::test::seleniumLaunch "$::test::selenium4Launcher --port" $params
    set driver [::selenium::WebDriver new http://127.0.0.1:$::test::seleniumPort/wd/hub $::selenium::DesiredCapabilities($::test::seleniumBrowser)]
    testConstraint handlesAlerts 1
    testConstraint cssSelectorsEnabled 1
    testConstraint javascriptEnabled 1
    return $driver
}

proc ::test::ieDriver {{params {}}} {
    package require selenium::ie
    set driver [::selenium::IEDriver new {*}$params]
    return $driver
}

proc ::test::webConnect {{drivernames {}}} {
    if {[info exist ::test::webDriver]} {
        incr ::test::webDriverCount
        return $::test::webDriver
    }
    set useconstraint 0
    if {$drivernames eq {}} {
        set drivernames [array names ::test::webDriverChecks]
        set useconstraint 1
    }
    foreach drivername $drivernames {
        if {!$useconstraint || [testConstraint $drivername]} {
            if {[info proc $drivername] eq $drivername} {
                if {[catch $drivername result]} {
                    puts stderr "$drivername error: $result"
                } else {
                    set caps [$result current_capabilities]
                    foreach c {handlesAlerts cssSelectorsEnabled javascriptEnabled} {
                        catch {testConstraint $c [dict get $caps $c]}
                    }
                    set ::test::webDriverCount 1
                    set ::test::webDriver $result
                    return $::test::webDriver
                }
            } else {
                puts stderr "$drivername error: unknown"
            }
        }
    }
    error "No suitable driver from list: $drivernames"
}

proc ::test::webDisconnect {{driver {}}} {
    if {$::test::webDriverCount <= 1} {
        if {[info exist ::test::webDriver] && ($driver eq "" || $driver eq $::test::webDriver)} {
            $::test::webDriver quit
            $::test::webDriver destroy
            unset ::test::webDriver
            testConstraint handlesAlerts 0
            testConstraint cssSelectorsEnabled 0
            testConstraint javascriptEnabled 0
            if {[info exist ::test::seleniumPid]} {
                ::test::seleniumKill
            }
            set ::test::webDriverCount 0
        } else {
            error "Unknown driver $driver"
        }
    } else {
        incr ::test::webDriverCount -1
    }
}

namespace import ::test::*
