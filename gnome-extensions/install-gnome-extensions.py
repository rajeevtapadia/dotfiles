
import requests
from bs4 import BeautifulSoup
import os
import subprocess

# Function to fetch extension ID from GNOME Extensions website
def get_extension_id(extension_name):
    search_url = f"https://extensions.gnome.org/extensions/?search={extension_name}"
    
    # Request the search page
    response = requests.get(search_url)
    if response.status_code != 200:
        print(f"Failed to fetch data for {extension_name}. Skipping...")
        return None
    
    # Parse the page content
    soup = BeautifulSoup(response.text, 'html.parser')
    
    # Find the extension ID (located in the URL of the first result)
    result = soup.find('a', href=True, text="View extension")
    if result:
        # Extract extension ID from the URL
        extension_url = result['href']
        extension_id = extension_url.split('/')[-2]  # Extract the ID from the URL
        return extension_id
    else:
        print(f"Extension {extension_name} not found on GNOME Extensions website.")
        return None

# Function to install and enable the extension using its ID
def install_extension(extension_id):
    # Install the extension
    url = f"https://extensions.gnome.org/extension/{extension_id}/download"
    response = requests.get(url)
    if response.status_code == 200:
        # Download and install the extension
        with open(f"{extension_id}.zip", "wb") as file:
            file.write(response.content)
        
        # Use the GNOME extensions CLI to install and enable the extension
        subprocess.run(["gnome-extensions", "install", f"{extension_id}.zip"])
        subprocess.run(["gnome-extensions", "enable", extension_id])
        print(f"Extension {extension_id} installed and enabled.")
    else:
        print(f"Failed to download extension {extension_id}.")

# Main function to process the list of extension names from ext.txt
def main():
    # Read the list of extension names from ext.txt
    if not os.path.exists("ext.txt"):
        print("ext.txt not found. Please provide the file with the list of extensions.")
        return

    with open("ext.txt", "r") as f:
        extension_names = [line.strip() for line in f.readlines()]

    # Create a file to store the extension IDs
    with open("enabled-extensions.txt", "w") as id_file:
        for extension_name in extension_names:
            # Fetch extension ID
            extension_id = get_extension_id(extension_name)
            if extension_id:
                id_file.write(extension_id + "\n")

    # Now read the extension IDs and install them
    with open("enabled-extensions.txt", "r") as f:
        extension_ids = [line.strip() for line in f.readlines()]

    for extension_id in extension_ids:
        install_extension(extension_id)

if __name__ == "__main__":
    main()
