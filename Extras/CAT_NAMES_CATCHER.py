import requests
from bs4 import BeautifulSoup

# Paste the CAT URL (MAKE SURE ITS FROM NOOKIPEDIA)
CAT_url = "https://nookipedia.com/wiki/Bug/New_Leaf"
titles = []

response = requests.get(CAT_url)
soup = BeautifulSoup(response.text, 'html.parser')

for row in soup.find_all('tr'):
    a_tag = row.find('a')
    if a_tag and a_tag.has_attr('title'):
        titles.append(a_tag['title'])

with open('Collectable(s)List.txt', 'a') as file:
    for title in titles:
        file.write(title + '=0\n')

print("DONE.")