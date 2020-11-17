namespace eval ::selenium {

    oo::class create Mixin_Action_Chains {

        # Making already set variables from higher scope available here
        variable Mouse_Button Command session_ID WEB_ELEMENT_ID

        method w3c_reset_actions {} {
            # FIXME my execute not defined for this class

            my execute $Command(W3C_RELEASE_ACTIONS) sessionId $session_ID
        }

        method w3c_click {{element_ID ""}} {
            # FIXME my scroll_into_view not defined for this class

            if {$element_ID ne ""} {
                my scroll_into_view $element_ID
                my w3c_move_to_element $element_ID
            }

            set action_payload {
                [
                 {
                   "type": "pointer",
                   "id": "mouse1",
                   "parameters": {"pointerType": "mouse"},
                   "actions": [
                     {"type": "pointerDown", "button": 0},
                     {"type": "pause", "duration": 150},
                     {"type": "pointerUp", "button": 0}
                   ]
                 }
                ]
            }

            my execute $Command(W3C_PERFORM_ACTIONS) sessionId $session_ID actions $action_payload
        }

        method w3c_click_and_hold {{element_ID ""}} {

            if {$element_ID ne ""} {
                my scroll_into_view $element_ID
                my w3c_move_to_element $element_ID
            }

             set action_payload {
                [
                 {
                   "type": "pointer",
                   "id": "mouse1",
                   "parameters": {"pointerType": "mouse"},
                   "actions": [
                     {"type": "pointerDown", "button": 0}
                   ]
                 }
                ]
             }

            my execute $Command(W3C_PERFORM_ACTIONS) sessionId $session_ID actions $action_payload
        }

        method w3c_context_click {{element_ID ""}} {

            if {$element_ID ne ""} {
                my scroll_into_view $element_ID
                my w3c_move_to_element $element_ID
            }

            set action_payload {
                [
                 {
                   "type": "pointer",
                   "id": "mouse1",
                   "parameters": {"pointerType": "mouse"},
                   "actions": [
                     {"type": "pointerDown", "button": 2},
                     {"type": "pause", "duration": 200},
                     {"type": "pointerUp", "button": 2}
                   ]
                 }
                ]
            }

            my execute $Command(W3C_PERFORM_ACTIONS) sessionId $session_ID actions $action_payload
        }

        method w3c_double_click {{element_ID ""}} {

            if {$element_ID ne ""} {
                my scroll_into_view $element_ID
                my w3c_move_to_element $element_ID
            }

            set action_payload {
                [
                 {
                   "type": "pointer",
                   "id": "mouse1",
                   "parameters": {"pointerType": "mouse"},
                   "actions": [
                     {"type": "pointerDown", "button": 0},
                     {"type": "pause", "duration": 150},
                     {"type": "pointerUp", "button": 0},
                     {"type": "pause", "duration": 200},
                     {"type": "pointerDown", "button": 0},
                     {"type": "pause", "duration": 150},
                     {"type": "pointerUp", "button": 0}
                   ]
                 }
               ]
            }

            my execute $Command(W3C_PERFORM_ACTIONS) sessionId $session_ID actions $action_payload
        }

        method w3c_drag_and_drop {element_start element_end} {

            my w3c_click_and_hold $element_start
            my w3c_move_to_element $element_end
            my w3c_release
        }

        method w3c_drag_and_drop_by_offset {element_ID xoff yoff} {

            if {$element_ID eq "" || ![string is integer -strict $xoff] || ![string is integer -strict $yoff]} {
                throw {Missing Parameters} {Error: an element ID, an x-offset integer, and a y-offset integer must be supplied}
            }

            my w3c_click_and_hold $element_ID
            my w3c_move_by_offset $xoff $yoff
            my w3c_release
        }

        method w3c_move_by_offset {xoff yoff} {

            # Moves the mouse to an offset from current mouse position
            if {![string is integer -strict $xoff] || ![string is integer -strict $yoff]} {
                throw {Missing Parameters} {Error: an x-offset integer, and a y-offset integer must be supplied}
            }

            set action_payload "

                \[
                 {
                   \"type\": \"pointer\",
                   \"id\": \"mouse1\",
                   \"parameters\": {\"pointerType\": \"mouse\"},
                   \"actions\": \[
                     {\"type\": \"pointerMove\", \"origin\": \"pointer\", \"duration\": 150, \"x\": $xoff, \"y\": $yoff}
                   \]
                 }
                 \]

            "

            my execute $Command(W3C_PERFORM_ACTIONS) sessionId $session_ID actions $action_payload
        }

        method w3c_move_to_element {element_ID {xoff ""} {yoff ""}} {

#           variable duration 150
            set duration 150

            if {$element_ID eq ""} {
                throw {Missing Element} {Error: Element ID Must Be Supplied}
            }

if 0 {
            if {[string is integer $xoff] && [string is integer $yoff]} {
                set element_rect [my execute $Command(W3C_GET_ELEMENT_RECT) sessionId $session_ID id $element_ID]
                set element_rect_x [expr {int( [dict get $element_rect value width] )}]
                set element_rect_y [expr {int( [dict get $element_rect value height] )}]

                set left_offset [expr {$element_rect_x / 2}]
                set top_offset [expr {$element_rect_y / 2}]

                # FIXME strange expr
#               set xcoord [expr -$left_offset + { $element_rect_x | 0} ]
#               set ycoord [expr -$top_offset + { $element_rect_y | 0} ]
                set xcoord [expr {-$left_offset + ($element_rect_x | 0)}]
                set ycoord [expr {-$top_offset + ($element_rect_y | 0)}]
            } else {
                set xcoord 0
                set ycoord 0
            }

            # selenium error: UnsupportedCommandException: POST /session/.../actions
            # chrome error: invalid argument\n from invalid argument: 'element' is missing
            set action_payload "

                \[
                 {
                   \"type\": \"pointer\",
                   \"id\": \"mouse1\",
                   \"parameters\": {\"pointerType\": \"mouse\"},
                   \"actions\": \[
                     {\"type\": \"pointerMove\", \"origin\": {\"element-6066-11e4-a52e-4f735466cecf\": \"$element_ID\"}, \"duration\": $duration, \"x\": $xcoord, \"y\": $ycoord}
                   \]
                 }
                 \]

            "
            # selenium error: UnsupportedCommandException: POST /session/.../actions 
            # chomee: no error no expected result
            set action_payload [format { [
                {
                    "type": "pointer",
                    "id": "mouse1",
                    "parameters": {"pointerType": "mouse"},
                    "actions": [
                        {"type": "pointerMove", "origin": {"ELEMENT": "%s", "%s": "%s"}, "duration": %d, "x": %d, "y": %d}
                    ]
                } ]
            } $element_ID $WEB_ELEMENT_ID $element_ID $duration $xcoord $ycoord]
} else {            
            # selenium: UnsupportedCommandException: POST /session/.../actions
            # chrome: ok
            set action_payload [format {\
                [\
                    {\
                        "type": "pointer",\
                        "id": "mouse1",\
                        "parameters": {"pointerType": "mouse"},\
                        "actions": [\
                            {"type": "pointerMove", "duration": %d, "x": %d, "y": %d}\
                        ]\
                    }\
                ]\
            } $duration 0 0]
}        
            my execute $Command(W3C_PERFORM_ACTIONS) sessionId $session_ID actions $action_payload
        }

        method w3c_move_to_element_with_offset {element_ID xoff yoff } {

            if {$element_ID eq "" || ![string is integer -strict $xoff] || ![string is integer -strict $yoff]} {
                throw {Missing Parameters} {Error: an element ID, an x-offset integer, and a y-offset integer must be supplied}
            }

            # Just call out to the other proc/method with the fully supplied signature.
            my w3c_move_to_element $element_ID $xoff $yoff
        }

        method w3c_send_keys {string_of_keys {element_ID ""}} {

            if {$element_ID ne ""} {
                #  Outsource this command straight to the /element/value endpoint
                my execute $Command(W3C_SEND_KEYS_TO_ELEMENT) sessionId $session_ID id $element_ID text $string_of_keys
            } else {
                set genlist ""
                for {set i 0} {$i < [string length $string_of_keys]} {incr i} {

                    # Iterate letters/unicode in string so we can create the individual JSON array list items.
                    set char [string index $string_of_keys $i]
                    set genlist \
                        [string cat $genlist \
                            "\n{\"type\": \"keyDown\", \"value\": \"$char\"},\n{\"type\": \"keyUp\", \"value\": \"$char\"}," ]

                    # Strip out the last comma otherwise it's wont be valid JSON object
                    if { $i == [string length $string_of_keys] - 1} {
                       set genlist [string trimright $genlist " \n\t,"]
                    }
                }

            # Else's for-loop completion so package up to be sent to Perform Actions
            set action_payload "
                            \[
                             {
                               \"type\": \"key\",
                               \"id\": \"keyboard\",
                               \"actions\": \[
                                 $genlist
                               \]
                             }
                               \]
                                    "

            my execute $Command(W3C_PERFORM_ACTIONS) sessionId $session_ID actions $action_payload
            }
        }

        method w3c_send_keys_to_element {string_of_keys element_ID} {

            if {$string_of_keys eq "" || $element_ID eq "" } {
                throw {Missing Parameters} {Error: an element ID and keys to send must be supplied.}
            }

            # The clicking of the element seems extraneous in my LIMITED testing as the "Element Send Keys" appears to grab focus.
            my w3c_click $element_ID

            # Wireshark shows that the JSON structure that is sent is as:
            # {"text": "\ue00fTest", "value": ["\ue00f", "T", "e", "s", "t"], "id": <snip>, "sessionId": <snip> }
            # However, manual testing simply sending the "text" key is valid and generates the "value" key.
            my w3c_send_keys $string_of_keys $element_ID
        }

        method w3c_release {} {

            my execute $Command(W3C_RELEASE_ACTIONS) sessionId $session_ID
        }


        #method release_pointer {{element_ID ""}} {
            ##  TODO Action Scheduler

        #}

        #method release_key {{element_ID ""}} {
            ## TODO Action Scheduler

        #}

        #method w3c_perform {} {
            ## TODO Action Scheduler

        #}

        #method key_down {value, {element ""}} {
            ## TODO Action Scheduler

        #}

        #method key_up {value {element ""}} {
            ## TODO Action Scheduler

        #}

        #method w3c_pause {seconds} {
            ## TODO Action Scheduler

        #}
    }

}
