#!/usr/bin/tclsh

package require tcltest
namespace import ::tcltest::*

configure {*}$argv -singleproc true -testdir [file dirname [info script]]

runAllTests
