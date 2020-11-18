# Exceptions that may happen in all the webdriver code.

namespace eval ::selenium {     
    namespace export Exception
    
    variable Exception 

    array set Exception {
        WebdriverException { SELENIUM WebdriverException unknown {
            Webdriver Exception
            }
        }
        
        ConnectionRefused { SELENIUM ConnectionRefused {
            Connection refused. It's not possible to reach webdriver server.
            }
        }

        NoSuchDriver { SELENIUM NoSuchDriver { 
            A session is either terminated or not started 
            }
        }
        
        ErrorInResponse { SELENIUM ErrorInResponse {
            Thrown when an error has occurred on the server side.
            
            This may happen when communicating with the firefox extension or the remote driver server.
            }
        }
        

        InvalidSwitchToTarget { SELENIUM InvalidSwitchToTarget {
            Thrown when frame or window target to be switched doesn't exist.
            }
        }

        NoSuchAttribute { SELENIUM NoSuchAttribute {
            Thrown when the attribute of element could not be found.
            
            You may want to check if the attribute exists in the particular browser you are
            testing against.  Some browsers may have different property names for the same
            property.  (IE8's .innerText vs. Firefox .textContent)
            }
        }

        ElementNotVisible { SELENIUM ElementNotVisible {
            Thrown when an element is present on the DOM, but
            it is not visible, and so is not able to be interacted with.
            
            Most commonly encountered when trying to click or read text
            of an element that is hidden from view.
            }
        }
        
        ElementIsNotSelectable { SELENIUM ElementIsNotSelectable {
            An attempt was made to select an element that cannot be selected.
            }
        }
        
        JavaScriptError { SELENIUM JavaScriptError {
            An error occurred while executing user supplied JavaScript. 
            }
        }
        
        XPathLookupError { SELENIUM XPathLookupError {
             An error occurred while searching for an element by XPath. 
            }
        }
        
        NoAlertOpen { SELENIUM NoAlertOpen {
            An attempt was made to operate on a modal dialog when one was not open. 
            }
        }
        
        InvalidElementCoordinates { SELENIUM InvalidElementCoordinates {
             The coordinates provided to an interactions operation are invalid.
            }
         }       
        
        UnexpectedTagName { SELENIUM UnexpectedTagName {
            Thrown when a support class did not get an expected web element.
            }
        }


        IMENotAvailable { SELENIUM IMENotAvailable {
            Thrown when IME support is not available. This exception is thrown for every IME-related
            method call if IME support is not available on the machine.
            }
        }
        
        IMEEngineActivationFailed { SELENIUM IMEEngineActivationFailed {
            Thrown when activating an IME engine has failed.} 
        }
        
        
        InvalidCommandMethod { SELENIUM InvalidCommandMethod {
            If a request path maps to a valid resource, but that resource does not respond to the request method,
            the server should respond with a 405 Method Not Allowed. The response must include an Allows header with a 
            list of the allowed methods for the requested resource. 
            }
        }
        
        MissingCommandParameters { SELENIUM MissingCommandParameters {
            If a POST/PUT command maps to a resource that expects a set of JSON parameters, and the response body does
            not include one of those parameters, the server should respond with a 400 Bad Request.
            The response body should list the missing parameters.   
            }
        }

        ElementClickIntercepted { SELENIUM ElementClickIntercepted {
            The Element Click command could not be completed because the element receiving the events is obscuring the element that was requested clicked.
            }
        }

        ElementNotSelectable { SELENIUM ElementNotSelectable {
            An attempt was made to select an element that cannot be selected.
            }
        }

        ElementNotInteractable { SELENIUM ElementNotInteractable {
            A command could not be completed because the element is not pointer- or keyboard interactable.
            }
        }

        InsecureCertificate { SELENIUM InsecureCertificate {
            caused the user agent to hit a certificate warning, which is usually the result of an expired or invalid TLS certificate.
            }
        }

        InvalidArgument { SELENIUM InvalidArgument {
            The arguments passed to a command are either invalid or malformed.
            }
        }

        InvalidCookieDomain { SELENIUM InvalidCookieDomain {
            An illegal attempt was made to set a cookie under a different domain than the current page.
            }
        }

        InvalidCoordinates { SELENIUM InvalidCoordinates {
            The coordinates provided to an interactions operation are invalid.
            }
        }

        InvalidElementState { SELENIUM InvalidElementState {
            A command could not be completed because the element is in an invalid state, e.g. attempting to click an element that is no longer attached to the document.
            }
        }

        InvalidSelector { SELENIUM InvalidSelector {
            Argument was an invalid selector.
            }
        }

        InvalidSessionId { SELENIUM InvalidSessionId {
            Occurs if the given session id is not in the list of active sessions, meaning the session either does not exist or that it’s not active.
            }
        }

        JavascriptError { SELENIUM JavascriptError {
            An error occurred while executing JavaScript supplied by the user.
            }
        }

        MoveTargetOutOfBounds { SELENIUM MoveTargetOutOfBounds {
            The target for mouse interaction is not in the browser’s viewport and cannot be brought into that viewport.
            }
        }

        NoSuchAlert { SELENIUM NoSuchAlert {
            An attempt was made to operate on a modal dialog when one was not open.
            }
        }

        NoSuchCookie { SELENIUM NoSuchCookie {
            No cookie matching the given path name was found amongst the associated cookies of the current browsing context’s active document.
            }
        }

        NoSuchElement { SELENIUM NoSuchElement {
            An element could not be located on the page using the given search parameters.
            }
        }

        NoSuchFrame { SELENIUM NoSuchFrame {
            A command to switch to a frame could not be satisfied because the frame could not be found.
            }
        }

        NoSuchWindow { SELENIUM NoSuchWindow {
            A command to switch to a window could not be satisfied because the window could not be found.
            }
        }

        ScriptTimeout { SELENIUM ScriptTimeout {
            A script did not complete before its timeout expired.
            }
        }

        SessionNotCreated { SELENIUM SessionNotCreated {
            A new session could not be created.
            }
        }

        StaleElementReference { SELENIUM StaleElementReference {
            A command failed because the referenced element is no longer attached to the DOM.
            }
        }

        Timeout { SELENIUM Timeout {
            An operation did not complete before its timeout expired.
            }
        }

        UnableToSetCookie { SELENIUM UnableToSetCookie {
            A command to set a cookie’s value could not be satisfied.
            }
        }

        UnableToCaptureScreen { SELENIUM UnableToCaptureScreen {
            A screen capture was made impossible.
            }
        }

        UnexpectedAlertOpen { SELENIUM UnexpectedAlertOpen {
            A modal dialog was open, blocking this operation.
            }
        }

        UnknownCommand { SELENIUM UnknownCommand {
            A command could not be executed because the remote end is not aware of it.
            }
        }

        UnknownError { SELENIUM UnknownError {
            An unknown error occurred in the remote end while processing the command.
            }
        }

        UnknownMethod { SELENIUM UnknownMethod {
            The requested command matched a known URL but did not match an method for that URL.
            }
        }

        UnsupportedOperation { SELENIUM UnsupportedOperation {
            Indicates that a command that should have executed properly cannot be supported for some reason.
            }
        }
    }

    proc Exception {exceptionName} {
        variable Exception
        return $Exception($exceptionName)
    }
}
