from scraper import scrape_ekantipur
from save_data import save_json
from utils import print_summary


def run_pipeline():
    print("Pipeline Started...")
    news = scrape_ekantipur()
    print_summary(news)
    save_json(news)
    print("Pipeline Finished")

if __name__ == "__main__":
    run_pipeline()