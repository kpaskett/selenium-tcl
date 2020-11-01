#!/usr/bin/tclsh

package require tcltest 2.5
namespace import ::tcltest::*

configure {*}$argv -singleproc true -testdir [file dirname [info script]]

runAllTests
