import pandas as pd
import ast

# Load your CSV
df = pd.read_csv("new_recipes1.csv", encoding='ISO-8859-1', low_memory=False)

# Parses lists into newline strings
def clean_to_newlines(raw_text):
    try:
        parsed = ast.literal_eval(raw_text)

        # If only one string, return cleaned
        if isinstance(parsed, str):
            return parsed.strip().strip('"')

        # If list, join with newline
        return '\n'.join(item.strip().strip('"') for item in parsed if item)
    except Exception as e:
        print(f"Error parsing: {raw_text}")
        return None

# Clean each target column if they exist
columns_to_clean = {
    'Keywords': 'cleaned_keywords',
    'RecipeIngredientQuantities': 'cleaned_quantities',
    'RecipeIngredientParts': 'cleaned_ingredients',
    'RecipeInstructions': 'cleaned_instructions'
}

for original_col, cleaned_col in columns_to_clean.items():
    if original_col in df.columns:
        df[cleaned_col] = df[original_col].dropna().apply(clean_to_newlines)
    else:
        print(f"Column '{original_col}' not found in the CSV.")

# Save cleaned columns to a new CSV
output_columns = list(columns_to_clean.values())
df[output_columns].to_csv("cleaned_output.csv", index=False)

print("Cleaned data for all columns saved to 'cleaned_output.csv'")
