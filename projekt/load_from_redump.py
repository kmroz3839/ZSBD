from bs4 import BeautifulSoup as bs
import requests

baseurl = "http://redump.org"
scan_urls = [
    "/discs/system/ps3/region/Eu",
    "/discs/system/psp/region/Eu"
]

entries = []
pages_urls = []

for url in scan_urls:
    response = requests.get(baseurl + url)
    html = response.text
    soup = bs(html, "html.parser")
    pages_div = soup.find("div", {"class": "pages"})
    pages_links = pages_div.find_all("a")
    pages_urls += [x.get('href') for x in pages_links]
    pages_urls.insert(0, url)

for page in pages_urls:
    print(f"processing: {page}...")
    response = requests.get(baseurl + page)
    html = response.text
    soup = bs(html, "html.parser")

    table = soup.find("table", {"class": "games"})
    rows = table.find_all("tr")
    for row in rows:
        tds = row.find_all("td")
        if len(tds) >= 6:
            editions = tds[4].text.strip()
            title_a = tds[1].find("a")
            title_span = title_a.find("span", {"class": "small"})
            title = title_span.text.strip() if title_span is not None else title_a.text.strip()
            for edition in editions.split(", "):
                entry = {
                    "title": title + f" ({edition})",
                    "platform": tds[2].text.strip(), 
                    "serial": tds[6].get('title').strip() if tds[6].get('title') is not None else tds[6].text.strip(),
                }
                #print(entry)
                entries.append(entry)

sql_file = "games.sql"
with open(sql_file, "w", encoding="utf-8") as f:
    f.write("""
CREATE TABLE IF NOT EXISTS games (
    serial VARCHAR(32) NOT NULL,
    title VARCHAR(300) NOT NULL,
    platform VARCHAR(8) NOT NULL,
    PRIMARY KEY (serial)
)
            """)
    for entry in entries:
        f.write("""
MERGE INTO games (serial, title, platform) VALUES (
    '{entry['serial'].replace("'", "''")}',
    '{entry['title'].replace("'", "''")}',
    '{entry['platform'].replace("'", "''")}'
);
            """)