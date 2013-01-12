# Free and Slow Google Translate API

## How to use it?

[>> Test it <<](http://google-translate-api.herokuapp.com/translate?from=en&to=ko&text[]=hi,%20how%20are%20you?&text[]=i'm%20fine,%20thank%20you&callback=test)

Test URL

* http://google-translate-api.herokuapp.com/translate

Query strings

* from - (Optional)[Language code](https://developers.google.com/translate/v2/using_rest#language-params) of text to translate. If this parameter is not provided, it will be detected. 
* to - Language code of target language
* text(or text[] when you request multiple texts) - text to translate. Up to 255 texts
* callback - callback function name for [JSONP](http://en.wikipedia.org/wiki/JSONP)

## What is this for?

I wanted to use Google Translate API for my toy project, but it wasn't free. I didn't wanted to pay for my toy project, so I made this. You may can use this for your side projects or something.

## How does it work?

It uses Google Spreadsheet API to translate.

## Limits

### Slow

It's very slow because it uses Google Spreadsheet to translate. It's much better if you query multiple texts at once.

### Not thread-safe

It's not thread-safe because it uses single spareadsheet to translate. However, it can process 1000 requests concurrently.

# References

* [Google Drive Ruby API](https://github.com/gimite/google-drive-ruby)
* [StackOverflow: Alternative to Google Translate API](http://stackoverflow.com/questions/6151668/alternative-to-google-translate-api#answer-8543979)
* [Google Docs, Sheets, and Slides size limits](http://support.google.com/drive/bin/answer.py?hl=en&answer=37603)
