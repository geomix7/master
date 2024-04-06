#!/usr/bin/python3
#python3 search.py ~/Documents/Nextcloud/Online_Services/ 'domain'
import os
import sys
import openpyxl
import pandas as pd

def find_word_in_excel(file_path, word):
    try:
        # Load the Excel file using openpyxl
        wb = openpyxl.load_workbook(file_path, data_only=True)
        ws = wb.active

        # Create an empty DataFrame to store the sheet data
        data = []

        for row in ws.iter_rows():
            row_data = [cell.value for cell in row]
            data.append(row_data)

        # Convert the sheet data into a DataFrame
        df = pd.DataFrame(data)

        # Search for the word in the DataFrame
        matches = df[df.apply(lambda row: row.astype(str).str.contains(word).any(), axis=1)]

        if not matches.empty:
            print(f"Word '{word}' found in '{file_path}':")
#            print(matches[[4,5]])
            print(matches)
#        else:
#            print(f"Word '{word}' not found in '{file_path}'")
#
    except Exception as e:
        print(f"An error occurred while processing '{file_path}': {str(e)}")

def find_in_directory(path, word):
    try:
        if os.path.isfile(path) and path.endswith(".xlsx"):
            find_word_in_excel(path, word)
        elif os.path.isdir(path):
            for root, _, files in os.walk(path):
                for file in files:
                    if file.endswith(".xlsx"):
                        file_path = os.path.join(root, file)
                        find_word_in_excel(file_path, word)
    except Exception as e:
        print(f"An error occurred: {str(e)}")

if __name__ == "__main__":
    if len(sys.argv) != 3:
        print("\tExecute: python searchpy.py <path> <word>")
        print("\tEg: python searchpy.py '/path/to/file' or '/path/' WordToSearch")
        sys.exit(1)

    find_in_directory(sys.argv[1], sys.argv[2])
