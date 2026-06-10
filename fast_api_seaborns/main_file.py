from fastapi import FastAPI
from fastapi.responses import StreamingResponse
import matplotlib.pyplot as plt
import seaborn as sns
import io

app = FastAPI(title="Dynamic Chart API")

# 1. BAR CHART API
@app.post("/chart/bar")
def bar_chart(data: dict):
    subjects = list(data.keys())
    marks = list(data.values())
    plt.figure(figsize=(6,4))
    sns.barplot(x=subjects, y=marks, color="green")
    plt.title("Bar Chart (Performance)")
    buf = io.BytesIO()
    plt.savefig(buf, format="png")
    buf.seek(0)
    plt.close()

    return StreamingResponse(buf, media_type="image/png")

# 2. LINE CHART API
@app.post("/chart/line")
def line_chart(data: dict):

    subjects = list(data.keys())
    marks = list(data.values())
    plt.figure(figsize=(6,4))
    sns.lineplot(x=subjects, y=marks, marker="o", color="green")
    plt.title("Line Chart (Trend)")
    buf = io.BytesIO()
    plt.savefig(buf, format="png")
    buf.seek(0)
    plt.close()

    return StreamingResponse(buf, media_type="image/png")


# 3. PIE CHART API
@app.post("/chart/pie")
def pie_chart(data: dict):

    labels = list(data.keys())
    values = list(data.values())

    plt.figure(figsize=(6,6))
    plt.pie(values, labels=labels, autopct="%1.1f%%",
            colors=["green", "lightgreen", "darkgreen", "lime"])

    plt.title("Pie Chart (Distribution)")
    buf = io.BytesIO()
    plt.savefig(buf, format="png")
    buf.seek(0)
    plt.close()

    return StreamingResponse(buf, media_type="image/png")

# 4. HOME
@app.get("/")
def home():
    return {
        "message": "Chart API Running 🚀",
        "endpoints": [
            "/chart/bar",
            "/chart/line",
            "/chart/pie"
        ]
    }