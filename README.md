Hello - iBeacon demo using Parse
=====

![Setup](http://i.imgur.com/5uzSI24.png)
![Nearby](http://i.imgur.com/CyQNUzf.png)

Requires iOS 7 on an iPhone 4S or newer

Before building:

<ul>
<li>Create a Parse app: https://www.parse.com/apps/new.</li>
<li>Change PARSE_APP_ID and PARSE_CLIENT_KEY in MCConfig.h to match your new app.</li>
</ul>

How to use:

<ul>
<li>Install Hello on two or more devices.</li>
<li>Start Hello and set unique names on all devices.</li>
<li>In the nearby view you should see other devices that are in range.</li>
<li>Devices are sorted and colored by distance: red is closest, yellow is furthest.</li>
</ul>

Notes:

<ul>
<li>This is a tech demo. Some things are not ready for production, for example, all Parse requests are done on the main thread.</li>
</ul>
