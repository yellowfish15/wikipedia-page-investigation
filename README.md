# Wikipedia Page Investigation
Stats investigation project of Wikipedia pages (M 358K)

## Generating pages
We randomly generate wikipedia pages using the API call <https://en.wikipedia.org/w/api.php?action=query&format=json&list=random&rnlimit=1>.

For documentation on this API call, please refer to <https://www.mediawiki.org/wiki/API:Random>.

Each random page returned contains three parameters:
1. **id**: numerical ID that is unique for the page
2. **ns**: a namespace specifying the type of page (for all namespace codes, refer to <https://en.wikipedia.org/wiki/Wikipedia:Namespace>)
3. **title**: the actual title of the page that can be used in the wikipedia URL to access the page HTML itself

