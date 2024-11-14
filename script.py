import random
import requests

WIKIPEDIA_API_URL = "https://en.wikipedia.org/w/api.php"
PAGEVIEWS_API_URL = "https://wikimedia.org/api/rest_v1/metrics/pageviews/per-article/en.wikipedia/all-access/all-agents/{}/daily/{}/{}"
MONTH_DAYS = {
    1: 31,  # January
    2: 28,  # February (non-leap year by default)
    3: 31,  # March
    4: 30,  # April
    5: 31,  # May
    6: 30,  # June
    7: 31,  # July
    8: 31,  # August
    9: 30,  # September
    10: 31, # October
    11: 30, # November
    12: 31  # December
}
# custom header to avoid 403 forbidden error
HEADERS = {
    'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36'
}

# generate a random date in 2023
def generate_random_date():
    year = 2023
    month = random.randint(1, 12)
    day = random.randint(1, MONTH_DAYS[month]) 
    return f"{year}{month:02d}{day:02d}"

# get a list of 'rnlimit' random article titles
# rnlimit specifies how many random pages to return
# rnnamespace specifies to only retrieve a specific type of namespace (if -1, allow all namespaces)
def get_random_articles(rnlimit=100, rnnamespace=-1):
    # rnlimit must be between [1, 500]
    if rnlimit > 500:
        rnlimit = 500
    if rnlimit < 1:
        rnlimit = 1
    params = {
        "action": "query",
        "format": "json",
        "list": "random",
        "rnlimit": rnlimit,
    }
    if rnnamespace != -1:
        params["rnnamespace"] = rnnamespace
    
    response = requests.get(WIKIPEDIA_API_URL, params=params, headers=HEADERS)
    data = response.json()
    return data['query']['random']

# get pageviews of an article
def get_pageviews(article_title, start_date, end_date):
    url = PAGEVIEWS_API_URL.format(article_title, start_date, end_date)
    response = requests.get(url, headers=HEADERS)
    if response.status_code == 200:
        data = response.json()
        try:
            pageviews = data['items'][0]['views']
            return pageviews
        except (IndexError, KeyError):
            return 0
    else:
        return 0

# get internal links count for a given article
def get_internal_links_count(article_title):
    params = {
        "action": "parse",
        "format": "json",
        "page": article_title,
        "prop": "links"
    }
    response = requests.get(WIKIPEDIA_API_URL, params=params, headers=HEADERS)
    data = response.json()
    
    if "parse" in data:
        links = data["parse"]["links"]
        return len([link for link in links if link.get('ns') == 0])  # Count only internal links
    else:
        return 0  # In case of errors or pages with no internal links


# main function to collect data for multiple samples
def collect_data(num_samples=100):
    results = []

    while len(results) < num_samples:
        pages = get_random_articles(rnlimit=(num_samples-len(results)), rnnamespace=0)
        for page in pages:
            # we are only interested in main articles, or ns=0 (https://en.wikipedia.org/wiki/Wikipedia:Namespace)
            if not page['ns'] == 0:
                continue
            page_title = page['title']
            
            # get a random date in 2023
            random_date = generate_random_date()

            # get pageviews for the article on that day
            views = get_pageviews(article_title=page_title, start_date=random_date, end_date=random_date)

            # get internal links count for the article
            internal_links_count = get_internal_links_count(article_title=page_title)

            results.append({
                'page_title': page_title, 
                'date': random_date, 
                'page_views': views, 
                'links_count': internal_links_count
                })   
    
    return results

# run the data collection for some number of samples
if __name__ == "__main__":
    samples = collect_data(100)
    print(samples)