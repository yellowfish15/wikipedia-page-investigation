# Wikipedia Page Investigation
Stats investigation project of Wikipedia pages (M 358K)

## How It Works
1. **Random Article Retrieval**
The script uses the Wikipedia API to fetch random article titles from the English Wikipedia. We only consider pages with namespace *0* (see generating pages section below for more information on this). You can specify how many random articles you'd like to retrieve (rnlimit parameter).

2. **Pageview Collection**
Using the [Wikimedia REST API](https://wikimedia.org/api/rest_v1/), the script fetches the number of pageviews for each article on a randomly generated date in 2023.

3. **Internal Link Count**
The script uses the Wikipedia API to fetch a list of internal links for each article. It counts only the internal links (links that point to other articles within Wikipedia).

4. **Sample Collection**
The ```collect_data()``` function collects the specified number of samples (articles), along with their pageviews and internal link counts.

## Generating Pages
We randomly generate wikipedia pages using the API call <https://en.wikipedia.org/w/api.php?action=query&format=json&list=random&rnlimit=1>.

For documentation on this API call, please refer to <https://www.mediawiki.org/wiki/API:Random>.

Each random page returned contains three parameters:
1. **id**: Numerical ID that is unique for the page
2. **ns**: Namespace specifying the type of page (for all namespace codes, refer to <https://en.wikipedia.org/wiki/Wikipedia:Namespace>). For this project, we are only interested in pages with ```ns=0```.
3. **title**: Actual title of the page that can be used in the wikipedia URL to access the page HTML itself


