from selenium import webdriver
from selenium.webdriver.common.by import By
from selenium.webdriver.chrome.options import Options
import time


def get_driver():
    options = Options()
    # options.add_argument("--headless=new")
    driver = webdriver.Chrome(options=options)
    return driver

def scrape_ekantipur():
    driver = get_driver()
    driver.get("https://ekantipur.com/business")
    time.sleep(3)
    all_urls = []
    image_urls = []
    for i in range(1, 6):
        try:
            path = f"/html/body/div[1]/div/div[{i}]/div/div[1]/h2/a"
            url = driver.find_element(By.XPATH, path).get_attribute("href")
            img = driver.find_elements(By.CLASS_NAME, "loaded")
            if len(img) > i:
                image_url = img[i].get_attribute("src")
            else:
                image_url = ""

            all_urls.append(url)
            image_urls.append(image_url)
        except Exception as e:
            print(e)
    news_data = []
    for idx, url in enumerate(all_urls):
        try:
            driver.get(url)
            time.sleep(2)
            title = driver.title
            news = driver.find_element(
                By.CLASS_NAME,
                "news-section-wrap-story"
            ).text

            news_data.append({
                "title": title,
                "news": news,
                "image_url": image_urls[idx],
                "news_url": url
            })

        except Exception as e:
            print(e)
    driver.quit()
    return news_data