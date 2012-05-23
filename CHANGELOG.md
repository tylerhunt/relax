# Changelog

## 0.2.0 – Unreleased

* Rewrote from scratch to be a smaller, simpler library

## 0.1.3 – August 31, 2009

* Added basic request logging
* Updated to Relief 0.0.4

## 0.1.2 – June 30, 2009

* Added support for proxies
* Added support for parameter name aliases
* Added an option to force blank values to be used

## 0.1.1 – June 3, 2009

* Added support for tokenized URL parameters
* Modified Service#authenticate to return self to allow chaining
* Extended parsers to allow for custom parser classes (Nathaniel Bibler)

## 0.1.0 – May 7, 2009

* Rewrote the API to use a DSL interface
* Replaced the embedded parsers with Relief

## 0.0.7 – April 27, 2009

* Added support for required request parameters

## 0.0.6 – February 3, 2009

* Fixed attribute-based parameters
* Fixed an issue with `node_name` in the new parsers (Nathaniel Bibler)

## 0.0.5 – October 20, 2008

* Added support for multiple parsers (Nathaniel Bibler)
* Added a REXML parser (Nathaniel Bibler)
* Added a GitHub gemspec and a Rake task for regenerating it

## 0.0.4 – November 17, 2007

* Added support for custom Request parameter types

## 0.0.3 – November 1, 2007

* Fixed that parameter values defined in ancestors weren't passed to children
* Added date and time parameter types to Response
* Added an accessor for the raw XML to Response

## 0.0.2 – October 10, 2007

* Renamed API to Service
* Added tutorial to the README
* Added Rdoc documentation
* Added support for custom Response parameter types

## 0.0.1 – September 27, 2007

* First public release
