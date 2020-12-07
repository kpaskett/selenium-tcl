package require selenium::utils::log

package provide selenium::utils::port 0.1

namespace eval ::selenium::utils::port {
    namespace import ::selenium::utils::log::log
    namespace export *
    
	proc is_connectable {port} {
		if {[catch {set sockChan [socket localhost $port]}]} {
			return false
		} else {
			close $sockChan
			return true
		}
	}

	proc get_free_port {} {
		set sockChan [socket -server [list apply [list args {}]] 0]
		set port [lindex [fconfigure $sockChan -sockname] 2]
		close $sockChan
		
		return $port
	}
    
    proc wait_until_connectable {port {max_attemps 30}} {
        set count 0
        while {! [is_connectable $port]} {
            if {$count == $max_attemps} {
                return 0
            }
            incr count
            log debug {wait disconnect $port $count/$max_attemps}
            after 1000
        }
        
        return 1
    }
    
    proc wait_until_not_connectable {port {max_attemps 30}} {
        set count 0
        while {[is_connectable $port]} {
            if {$count == $max_attemps} {
                return 0
            }
            incr count
            log debug {wait connect $port $count/$max_attemps}
            after 1000
        }
        
        return 1
    }
    
}
