#
# selenium::utils::log
#
# simple logging package, naviserver-style, https://bitbucket.org/naviserver.
#

namespace eval ::selenium::utils::log {
    namespace export *

    variable handle "stderr"
    variable severities
    array set severities {
        fatal 1
        error 1
        warning 1
        notice 1
        debug 0
        bug 0
    }

    proc logctl {command args} {
        variable severities
        variable handle
        switch -- $command {
            "handle" {
                switch [llength $args] {
                    0 {return $handle}
                    1 {return [set handle [lindex $args 0]]}
                    default {error "logctl: invalid args, should be logctl handle ?value?"}
                }
            }
            "open" {
                if {[catch {open [lindex $args 0] "a"} result]} {
                    error "logctl: error opening '[lindex $args 0]', $result"
                    return ""
                } else {
                    set handle $result
                    return $handle
                }
            }
            "flush" {
                if {[catch {flush $handle} result]} {
                    error "logctl: flush error $result"
                }
            }
            "close" {
                if {$handle ni {"stderr" "stdin"}} {
                    if {[catch {close $handle} result]} {
                        error "logctl: close error $result"
                    }
                }
            }
            "severities" {
                return [array names severities {*}args]
            }
            "severity" {
                switch [llength $args] {
                    1 {return [expr {[info exists severities([lindex $args 0])] ? $severities([lindex $args 0]) : 0}]}
                    2 {return [set severities([lindex $args 0]) [lindex $args 1]] }
                    default {error "logctl: invalid args, should be logctl severity name ?value?"}
                }
            }
            default {error "logctl: invalid command $command, should be logctl handle|severities|severity"}
        }
        return ""
    }

    #
    # Notice logged expression will be evaluated, like for 'expr' parameter.
    # Place it between curly braces.
    #
    # Example: log debug {a = $a} 
    #
    proc log {severity args} {
        if {[logctl handle] ne "" && [logctl severity $severity]} {
            set l $severity
            lappend l [uplevel namespace current]
            lappend l [expr {[info level] <= 1 ? [file tail [info script]] : [lindex [info level -1] 0]}]:
            foreach arg $args {
                if {[catch {uplevel subst [list $arg]} result]} {
                   lappend l "(LOGERROR $result ON $args)"
                } else {
                   lappend l $result
                }
            }
            if {$severity in {"bug" "error" "fatal"}} {
               lappend l "\nCALL STACK:[uplevel [namespace current]::stack]"
            }
            if {[catch {puts [logctl handle] [join $l " "]} result]} {
                error "log: write error $result"
            }
        }
        return ""
    }

    proc stack {} {
        set retval {}
        for {set i 1} {$i < [info level]} {incr i} {
            append retval "\n#$i [uplevel \#$i namespace current] [string range [info level $i] 0 80]"
        }
        return $retval
    }
}

package provide selenium::utils::log 0.1
