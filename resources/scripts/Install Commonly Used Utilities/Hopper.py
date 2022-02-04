#!/usr/bin/env python
import urllib2
import urllib
import json
headers = { 'User-Agent' : 'Mozilla/5.0' }
req = urllib2.Request('http://hopperapp.com/include/files-api.php?request=releases',None,headers)
print "Loading Hopper URL API"
response = urllib2.urlopen(req)
the_page = response.read()
JSON=json.loads(the_page)
OSXJSON=JSON["OS X"]
url=OSXJSON["filename"]
print "Downloading Hopper Latest With Size:",OSXJSON["file_length"]
urllib.urlretrieve (url, "Hoppper-Latest.zip")