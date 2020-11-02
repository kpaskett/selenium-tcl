#!/usr/bin/tclsh

package require tcltest
namespace import ::tcltest::*

configure {*}$argv -singleproc true -testdir [file dirname [info script]]

set java [expr {[info exists env(JAVA_HOME)] ? [file join $env(JAVA_HOME) bin java] : "java"}]
set selenium [expr {[info exists env(SELENIUM)] ? $env(SELENIUM) : "/usr/local/lib/selenium"}]
set htmlunitlauncher "-cp $selenium/htmlunit-driver-2.44.0-jar-with-dependencies.jar:$selenium/selenium-server-standalone-3.141.59.jar org.openqa.grid.selenium.GridLauncherV3"
set seleniumlauncher "-jar $selenium/selenium-server-standalone-3.141.59.jar"
set selenium4launcher "-jar $selenium/selenium-server-4.0.0-alpha-6.jar standalone"

#testConstraint seleniumBrowsers 1

puts ""
puts "Be sure to have commented out ALL Drivers in 10-drivers.test !!!"
puts ""

foreach {_driver _check} {
    chromeDriver    "exec chromedriver --version"
    geckoDriver     "exec geckodriver --version"
    operaDriver     "exec operadriver --version"
    ieDriver        "exec iedriverserver --version"
    phantomjsDriver "exec phantomjs --version"
    htmlunitDriver  "exec $java {*}$htmlunitlauncher --version"
    seleniumDriver  "exec $java {*}$seleniumlauncher --version"
    selenium4Driver "exec $java {*}$selenium4launcher --version"
} {
    if {[expr {![catch $_check]}]} {
        puts "*** Test for $_driver begins"
        testConstraint $_driver 1
        source 10-driver.test
        testConstraint $_driver 0
        puts "*** Test for $_driver end"
    } else {
        puts "*** Test for $_driver skipped"
    }
}
