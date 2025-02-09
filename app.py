from flask import Flask

app = Flask(__name__)

@app.route("/")
def home():
    return "<h1>Welcome to the Vulnerable Web App</h1>"

@app.route("/test")
def test():
    return "<p>This is a test page with potential security flaws.</p>"

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=9080, debug=True)
