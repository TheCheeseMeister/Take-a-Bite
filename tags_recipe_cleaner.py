import pandas as pd

# === CONFIG ===
input_csv = "final_recipes.csv"      # Input file
output_csv = "tags_recipes.csv"      # Output file for import
tag_column = "Keywords"              # Correct column name

# === Load the CSV ===
df = pd.read_csv(input_csv)

# === Prepare the output rows ===
rows = []
tags_recipes_id = 1

for index, row in df.iterrows():
    recipe_id = index + 1  # Assuming recipe_id aligns with row number
    raw_tags = row.get(tag_column)

    if pd.isna(raw_tags):
        continue

    # Split tags on newlines and clean them
    tags = [tag.strip() for tag in raw_tags.split('\n') if tag.strip()]

    for tag in tags:
        rows.append({
            "tags_recipes_id": tags_recipes_id,
            "recipe_id": recipe_id,
            "tag_name": tag
        })
        tags_recipes_id += 1

# === Save to CSV ===
output_df = pd.DataFrame(rows)
output_df.to_csv(output_csv, index=False)

print(f" Exported {len(rows)} tag-recipe links to '{output_csv}'")
