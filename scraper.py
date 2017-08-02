#import libraries
import urllib2
import json
import re
import redis
from bs4 import BeautifulSoup

def checkLink(url):
	returnedData = makeRequest(url)

	if returnedData:
		if returnedData.find("vodlocker.to") > 0:
			return makeCheckReq(returnedData)
		else:
			return returnedData

#When title is known - 
def getLinkForTitle (movieTitle):
	url = "http://vodlocker.to/embed?t=" + movieTitle + "&referrer=link&server=alternate"
	return checkLink(url)

#When tmdb is known
def getLinkForId(tmdbId):
	url = url = "http://vodlocker.to/embed?i=" + tmdbId + "&referrer=link&server=alternate"
	return checkLink(url)

#Used to initialize a soup object
def soup(url):
	#Will reject connection unless this is specified
	hdr = {'User-Agent': 'Mozilla/5.0'}

	#Format request
	req = urllib2.Request(url, headers=hdr)

	#Execute request
	page = urllib2.urlopen(req)

	#Initialize BS object with page var
	return BeautifulSoup(page, "html.parser")

#Used for a default request
def makeRequest(url):
	
	#Strings from BS object
	myStrings = soup(url).strings

	#Iterate over object and find all instances specified by regEx (in this case URLs)
	for string in myStrings:
		myString = repr(string)

		search = re.search("(?P<url>https?://[^\s]+\")", myString)
	
		if search != None:
			return search.group()[:len(search.group(0))-3]
			#return search.group(0)[:len(search.group(0))-3]

#Used when the url is not a video - goes to a url checker page that has the working link
def makeCheckReq(url):

	for tag in soup(url).find_all('input'):
		newString = str(tag.get('value'))

		boolCheck = newString.find('http') > -1

		if boolCheck:
			return newString


print getLinkForTitle("transformers")
print getLinkForTitle("last_airbender")
print getLinkForTitle("asdfasdfa")
	
