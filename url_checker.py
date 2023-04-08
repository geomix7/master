#!/bin/env python3
from urllib.request import urlopen
from urllib.error import URLError
from urllib.error import HTTPError
from http import HTTPStatus
import sys

URLS = str(sys.argv[1]).split(',')

# get the status of a websites
def get_website_status(url):
# handle connection errors
  try:
# open a connection to the server with a timeout
      with urlopen(url, timeout=3) as connection:
# get the response code, e.g. 404
          code = connection.getcode()
          return code
  except HTTPError as e:
      return e.code
  except URLError as e:
      return e.reason
  except:
      return e

# interpret an HTTP response code into a status
def get_status(code):
    if code == HTTPStatus.NOT_FOUND:
        return 'OK'
    return 'ERROR'

# check status of a list of websites
def check_status_urls(urls):
    for url in urls:
# get the status for the website
        code = get_website_status(url)
# interpret the status
        status = get_status(code)
# report status
        print(f'{url:20s}\t{status:5s}\t{code}')
# list of urls to check


# check all urls
check_status_urls(URLS)