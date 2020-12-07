package require selenium::chrome

package provide selenium::chromium 0.1

namespace eval ::selenium::webdrivers::chromium {
    namespace export ChromiumDriver
    
    oo::class create ChromiumDriver {
        superclass ::selenium::ChromeDriver
        
        constructor {args} {
            array set options $args
            
            if {![info exists options(-browser_binary)]} {
                if {$::tcl_platform(platform) eq "windows"} {
                    # Look for Chromium in Windows Registry
                    lappend args -browser_binary [exec where chromium-browser.exe]
                } else {
                    lappend args -browser_binary [exec which chromium-browser]
                }
            }

            next {*}$args
        }
    }
}

namespace eval ::selenium {
    namespace import ::selenium::webdrivers::chromium::ChromiumDriver
    namespace export ChromiumDriver
}

