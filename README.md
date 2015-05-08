hubot-karma-simple
==============

Give (or take away) karma from people.

API
---

* `thing++` - add a point to `thing`
* `thing--` - remove a point from `thing`
* `hubot karma-simple alias <thing> <alias thing>` set|delete alias thing 
* `hubot karma-simple black_list <thing>` set|delete black_list 
* `hubot karma-simple increment_message <message>` set|delete increment_message 
* `hubot karma-simple decrement_message <message>` set|delete decrement_message 

## Installation

Run the following command 

    $ npm install hubot-karma-simple

Then to make sure the dependencies are installed:

    $ npm install

To enable the script, add a `hubot-karma-simple` entry to the `external-scripts.json`
file (you may need to create this file).

    ["hubot-karma-simple"]
