import pandas as pd
import re
import ast

# Load the CSV
df = pd.read_csv("new_recipes.csv", encoding='ISO-8859-1', low_memory=False)

# Function to clean each ingredient entry
def clean(ingredient):
    if pd.isna(ingredient):
        return None

    ingredient = ingredient.strip()

    # Remove the leading c( 
    ingredient = re.sub(r'^c\(', '', ingredient, flags=re.IGNORECASE)

    # Remove trailing ) or quotes
    ingredient = re.sub(r'[\)"\']+$', '', ingredient)

    # Final trim of whitespace/quotes
    ingredient = ingredient.strip(' "\'\n\t\r')

    return ingredient.lower() if ingredient else None

# Process the RecipeIngredientParts column
if 'RecipeIngredientParts' in df.columns:
    # Ingredients are split and placed into own cells
    ingredient_list = df['RecipeIngredientParts'].dropna().astype(str).str.split(',').explode()

    # Clean each ingredient
    cleaned_ingredients = ingredient_list.apply(clean).dropna()

    # Deduplicate
    seen = set()
    final_ingredients = []
    for item in cleaned_ingredients:
        key = (item, len(item))
        if key not in seen:
            seen.add(key)
            final_ingredients.append(item)

    # Save the cleaned ingredient dataset
    pd.Series(final_ingredients, name="ingredient").to_csv("cleaned_ingredients.csv", index=False)
    print("Cleaned ingredients saved to 'cleaned_ingredients.csv'")
else:
    print("Column 'RecipeIngredientParts' not found.")
