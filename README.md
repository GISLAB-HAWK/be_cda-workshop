# BE Climate Data Analysis (CDA) Workshop
*Biodiversity-Exploratories Climate Data Analysis Workshop*

## Setup Instructions

Follow these steps to prepare your workspace:

1. **Download the workshop files**  
   [**>> Download ZIP archive <<**](https://github.com/GISLAB-HAWK/be_cda-workshop/archive/refs/heads/main.zip)

   *Short link to ZIP file <https://s.gwdg.de/RthPDY>*
   

2. **Extract and open the project**  
   Unzip the downloaded file, then double-click `be_cda-workshop.Rproj` to open the project in **RStudio**.

3. **Set up your TubeDB credentials**  
   Copy `accounts_template.yaml` to `accounts.yaml` and open it in your preferred text editor. Replace the placeholder values with your actual credentials:
   ```yaml
   tubedb: {url: 'YOUR_URL_AND_PORT', user: 'YOUR_USERNAME', password: 'YOUR_PASSWORD'}
   ```

4. **Run the the tutorials scripts**  
   All tutorial scripts are located in the `scripts` folder.  
  `0_init.R` is the setup script that is run at the beginning of each tutorial script.  
   The tutorial scripts are numbered in ascending order, with the first being `1_metadata.R`.

## Project Structure
- **`data/`** - Output folder for generated files and results
- **`scripts/`** - Contains all tutorial scripts (`0_init.R`, `1_metadata.R`, etc.)
- **`accounts.yaml`** - Your personal TubeDB credentials (copy from `accounts_template.yaml`)
- **`accounts_template.yaml`** - Template file for TubeDB credentials
- **`be_cda-workshop.Rproj`** - RStudio project file
