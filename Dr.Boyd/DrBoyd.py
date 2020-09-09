"""
Project: Dr. Boyd's Calcium Data
Start: 8th September 2020
End:
"""

"Import the data from 178 separate links:"

# Import the necessary libraries:
import pandas as pd

# To get the data url links (via a printf statement):
for i in range(179):
    print(f"https://academic.csuohio.edu/holcombj/clean/obs{i}.htm")

# To parse the table from a single link
a = pd.read_html("https://academic.csuohio.edu/holcombj/clean/obs1.htm")
print(a)

# To parse the data from multiple links (via a for loop):
for link in links:
    pd.read_html(link)
