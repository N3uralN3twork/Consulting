"""
Project: Dr. Boyd's Calcium Data
Start: 8th September 2020
End: 9th September 2020
Source: https://academic.csuohio.edu/holcombj/clean/bigtable.htm
"""

# Import the necessary libraries:
import pandas as pd
import numpy as np


# To get a single observation from a url link (via a printf statement):
for i in range(1, 179):  # For the 178 separate links:
    print(f"https://academic.csuohio.edu/holcombj/clean/obs{i}.htm")  # Print each link

# Store the results in a list:
links = []  # Start with an empty list to hold the urls
for i in range(1, 179):
    links.append(str(f"https://academic.csuohio.edu/holcombj/clean/obs{i}.htm"))

# To parse the table from a single link
a = pd.read_html("https://academic.csuohio.edu/holcombj/clean/obs1.htm", header=None)
print(a)

# To parse the data from multiple links (via a for loop):
data = []
for link in links:  # For each link in the above list:
    data.append(pd.read_html(link))  # Append the table to the new list

A = np.array([np.array(x) for x in data])  # Turn the list of data into an NDarray

df = pd.DataFrame(data=A.flatten(order="K"))  # Remove the unnecessary dimension (1)

B = np.reshape(A, newshape=(-1, 16))  # Reshape the array into a dataframe with 16 columns (2*8)

C = pd.DataFrame(B)  # Turn the array into a Pandas DataFrame

finale = C.iloc[:, [1, 3, 5, 7, 9, 11, 13, 15]]  # Select all rows and only the odd columns

finale.columns = ["Obs.", "Age", "Sex", "AlkPhos", "Lab", "CamMOL", "PhosMOL", "AgeGroup"]  # Supply column names

# Write to Excel:
pd.DataFrame.to_excel(finale, "CleanedCalcium.xlsx",
                      header=True, index=False)


