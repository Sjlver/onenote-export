OneNote Export
==============

A simple, minimalistic tool to export a set of OneNote notebooks to a folder
structure with HTML files. I wrote this because I couldn't find any existing
tool that would do this (and didn't require Windows, Office, or whatever).

Usage
-----

1. Clone this repo:

        git clone git@github.com:Sjlver/onenote-export.git

2. Install dependencies:

        bundle install

3. Get an API token.

   The easiest way I know to do this is to go to [the Apigee
   console](https://apigee.com/onenote/embed/console/onenote). There, click on
   `Authentication` > `OAuth 2 Implicit Grant`. This will prompt you to log in to
   your Microsoft account.

   Once you logged in, select some GET request from the menu (e.g.,
   `https://www.onenote.com/api/v1.0/notebooks`). Click on `Send` to perform
   the request.

   At the left side of the screen, you can see the request that has been
   performed. Copy the value of the authentication header (the part that says
   `Bearer xyz...`) and save it in the environment variable `AUTH_TOKEN`.

4. Start the export:

        bundle exec ./onenote_export.rb
