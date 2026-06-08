def print_summary(data):
    print("\nSCRAPING SUMMARY")
    print("-" * 40)
    for item in data:
        print(item["title"])