import pandas as pd
import random

# === CONFIG ===
input_file = "abcd.csv"
output_file = "ri_newest.csv"
measurement_column = "ri_ingredient_measurement"

# Random units to append
units = ["tsp", "tbsp", "cup", "oz", "g", "ml", "pinch", "dash", "clove", "piece"]

# Load CSV
df = pd.read_csv(input_file)

# Function to apply unit unless it's "to taste"
def append_random_unit(measurement):
    if isinstance(measurement, str) and "to taste" in measurement.lower():
        return measurement  # leave unchanged
    elif isinstance(measurement, str):
        unit = random.choice(units)
        return f"{measurement} {unit}"
    else:
        return measurement  # leave blank or non-string as-is

# Apply transformation
df[measurement_column] = df[measurement_column].apply(append_random_unit)

# Save new CSV
df.to_csv(output_file, index=False)
print(f" Updated measurements saved to '{output_file}'")
