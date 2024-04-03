from flask import Flask, render_template, request, jsonify
from langchain_openai import AzureOpenAI
import os
from dotenv import load_dotenv

# Load the environment variables
load_dotenv()

# Create an instance of Azure OpenAI
# Replace the deployment name with your own
llm = AzureOpenAI(
    deployment_name="gpt35instruct",
)

app = Flask(__name__)


@app.route('/api/ask', methods=['POST'])
def ask():
    data = request.get_json()
    question = data['question']
    response = llm.invoke(question)
    return jsonify({'response': response})


@app.route('/')
def index():
    return render_template('index.html')


if __name__ == '__main__':
    app.run(debug=True)
