# Analysis of Voting Behavior in the 2022 U.S. Midterm Elections

## 🗳️ Overview
This project examines voting behavior in the 2022 U.S. midterm election using Comprehensive Election Study (CES) 2022 data and logistic regression.

### ⭐️ Inspiration
In 2024, 4 Democratic Senators were elected in states that President-Elect Donald Trump won. Elissa Slotkin (MI), Tammy Baldwin (WI), and Jackie Rosen (NV) all received fewer votes than Kamala Harris in their respective states. Ruben Gallego (AZ) is the only Democratic U.S. Senate candidate who won a state that Kamala Harris lost and received more votes than her. We know that pollsters have consistently underestimated support for Trump and turnout in U.S. Senate races is typically lower than in presidential races. We also know that Trump drives up turnout, both for and against him. My goal to analyze why Harris voters in swing states were more likely to vote for down-ballot Democrats than Trump voters were to vote for down-ballot Republicans inspired this project. 

### 👀 Key Insights
- Hindsight is 20/20. My logistic regression vote preference model, which was trained on CES 2022 data, estimated high support for Trump amongst men ages 18-29 across most races and education levels.
- The **Trump only** voter is a thing. My logistic regression analysis found that voters with no college education, distrust in government, and low civic engagement are likely to support Trump, but less likely to vote in a midterm election where he is not on the ballot.
- Low-propensity and low-frequency presidential election voters are unlikely to vote in the subsequent midterm election. 

## 🗂️ File Structure

The repo is structured as:

-   `data/raw_data` contains the raw data as obtained from Harvard Dataverse.
-   `data/analysis_data` contains the cleaned dataset that was constructed.
-   `model` contains fitted models. 
-   `other` contains relevant literature, details about LLM chat interactions, sketches, a datasheet and a model card.
-   `paper` contains the files used to generate the paper, including the Quarto document and reference bibliography file, as well as the PDF of the paper. 
-   `scripts` contains the R scripts used to simulate, download and clean data.


## 🤖 Statement on LLM usage
Aspects of this code, including the data visualizations and tables, were created with the assistance of a Large Language Model, ChatGPT-3.5. The entire interaction history with ChatGPT is available in other/llms/usage.txt.

## 👩🏻‍💻 Possible Next Steps
Trump will be term-limited in 2028. My goal is to use 2024 pre and post-election survey data to develop a model that predicts whether an individual who voted in the presidential race will also vote in Senate and other down-ballot races that appear on the same ballot, and in a future midterm or presidential election once their preferred presidential candidate is no longer on the ballot.
