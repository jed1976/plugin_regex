RegEx 1.0.3
===========

Hello. Thank you for downloading the RegEx plug-in for Coda 2.

This plug-in enables you to text regular expression patterns on any text you want in real-time.

To start, simply choose RegEx… from the plug-ins menu or press Control-Option-Command-R.

In the first text field, you can type any regular expression pattern you want.

In the textarea, you can type or paste the subject text in which you wish to text with.

Any matches will highlight in a light sky blue by default. To change the highlight color, choose Highlight Color… from the action menu in the bottom left. You may also choose whatever font you want for the editor in the action menu.

In addition, the number of matches will display on the bottom right.

For a quick reference guide to regular expressions, click the ? button.

In addition to testing regular expressions, you can easily create your own patterns and save them in a group of your choice.

Clicking the + button on the bottom left will reveal a menu in which you can add a regular expression or a group.

If you remove a group or regular expression on accident, you can use Control-Z or Undo/Redo from Coda's Edit menu.

Finally, you can choose to ignore case, all dotall matches, match at line breaks and use secondary highlight color in the action menu.

All preferences and regular expressions/groups will be saved and available on subsequent uses.


Installation
============

For best result, please do the following:

1. Close Coda 2
2. Open Coda 2
3. Double-click not the "RegEx.codaplugin" file

You should find the "RegEx..." option under the Plug-ins menu item in Coda 2.


Uninstallation
==============

For best result, please do the following:

1. Close Coda 2
2. In Finder, navigate to: /Users/YOUR USER DIRECTORY/Library/Application Support/Coda 2/Plug-ins/
3. Select the "RegEx.codaplugin" file and move it to the Trash
4. Open Coda 2


Problems or Questions
=====================

If you run into any issues using this plug-in or just have general comments or recommendations, please contact me @joedakroub via Twitter or joe.dakroub@me.com.


License
=======

RegEx is distributed under The MIT License (MIT). Please refer to 'LICENSE' file for more information.


Credits
=======

RegEx makes use of the very excellent RegexKitLite library:

RegexKitLite: Lightweight Objective-C Regular Expressions for Mac OS X using the ICU Library (http://regexkit.sourceforge.net/RegexKitLite/) BSD License

Licenses for this library have been included in the 'licenses' directory of this distribution. 


Changelog
=========

Version 1.0.3

* Fixed an issue where the insertion cursor would always move to the end of the line when matches were found. Thank you Mike Erickson for the find!


Version 1.0.2

* Fixed the non-saving issue for new RegEx patterns and groups


Version 1.0.1

* Added a secondary highlight color option
* Matched characters font color will dynamically adjusted from black to white based on your chosen highlight color's hue


Version 1.0

* Initial release