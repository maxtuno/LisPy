(py:run "from textblob import TextBlob
def analyze_sentiment(text):
    blob = TextBlob(text)
    return {'polarity': blob.sentiment.polarity}")
