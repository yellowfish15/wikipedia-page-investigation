# Wikipedia Page Investigation
Stats investigation project of Wikipedia pages (M 358K)

## How It Works
### 1. **Random Article Retrieval**
   - The script fetches a specified number of random article titles from the **Wikipedia API** (`https://en.wikipedia.org/w/api.php?action=query&format=json&list=random&rnlimit=<limit>`). 
   - You can specify how many random articles you'd like to retrieve (parameter `rnlimit`).
   - We focus on articles within the main namespace (ns=0).

### 2. **Pageview Collection**
   - The script uses the **Wikimedia REST API** (`https://wikimedia.org/api/rest_v1/metrics/pageviews/per-article/en.wikipedia/all-access/all-agents/{article}/daily/{start_date}/{end_date}`) to retrieve pageview data for each article.
   - A **random date** in 2023 is generated for each article, and its pageview data is collected for that day.

### 3. **Internal Link Count**
   - The **Wikipedia API** is also used to retrieve a list of internal links from each article (`https://en.wikipedia.org/w/api.php?action=parse&format=json&page=<article>&prop=links`).
   - The number of internal links is counted, focusing only on internal links (i.e., links pointing to other Wikipedia pages).

### 4. **Concurrency for Faster Execution**
   - To improve the performance, the script uses **Python’s `ThreadPoolExecutor`** for concurrent fetching of both pageviews and internal link data.
   - By running multiple requests in parallel, the data collection process is significantly faster.

### 5. **Sample Collection and Output**
   - Data is collected for the specified number of random articles, and the results are stored in a **CSV file** (`wikipedia_data.csv`).


## Generating Pages
We randomly generate wikipedia pages using the API call <https://en.wikipedia.org/w/api.php?action=query&format=json&list=random&rnlimit=1>.

For documentation on this API call, please refer to <https://www.mediawiki.org/wiki/API:Random>.

Each random page returned contains three parameters:
1. **id**: Numerical ID that is unique for the page
2. **ns**: Namespace specifying the type of page (for all namespace codes, refer to <https://en.wikipedia.org/wiki/Wikipedia:Namespace>). For this project, we are only interested in pages with ```ns=0```.
3. **title**: Actual title of the page that can be used in the wikipedia URL to access the page HTML itself

## Code Explanation

### `generate_random_date()`
   - This function generates a random date in 2023. The date is formatted as `YYYYMMDD`.

### `get_random_articles()`
   - This function uses the **Wikipedia API** to retrieve random article titles. The number of articles to fetch is specified by the `rnlimit` parameter.

### `get_pageviews()`
   - Fetches the number of pageviews for a given article title on a specific date using the **Wikimedia REST API**.

### `get_internal_links_count()`
   - Retrieves the count of internal links (links to other Wikipedia articles) for a given article using the **Wikipedia API**.

### `analyze_article()`
   - This function performs the analysis of an individual article. It concurrently fetches both the pageview data and the internal links count using the `ThreadPoolExecutor`.

### `collect_data()`
   - This function coordinates the collection of data for multiple articles. It fetches random articles, then performs the analysis concurrently for each article. The results are stored in a list, ensuring thread safety using a `Lock`.

### `save_to_csv()`
   - Saves the collected data to a CSV file. The CSV contains columns for the article title, date, page views, and the count of internal links.

### `timer_wrapper()`
   - A helper function used to track the execution time of the data collection process.

## Example of the Output CSV File

The CSV file (`wikipedia_data.csv`) contains the following columns:

| page_title                         | date     | page_views | links_count |
|:-----------------------------------|:--------:|:----------:|:-----------:|
| "Python (programming language)"    | 20230115 | 51234      | 245         |
| "Artificial intelligence"          | 20230504 | 64200      | 210         |
| "Climate change"                   | 20230721 | 21345      | 150         |
| "Quantum computing"                | 20231010 | 38765      | 320         |
| "Machine learning"                 | 20230215 | 47012      | 175         |

- **page_title**: The title of the article.
- **date**: The random date in 2023 for which the pageview data was collected (in `YYYYMMDD` format).
- **page_views**: The number of pageviews for the article on the specified date.
- **links_count**: The number of internal links within the article (links to other Wikipedia articles).

This table represents an example of how the output data will look when saved to a CSV file.


