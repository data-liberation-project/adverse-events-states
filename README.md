# Adverse Events Statewide Data

## Project Structure

```text
├── California/
│   └── CA-Hospital Data with Geocodes.csv
│   └── CA - Final_PRA_29194 - 2026-04-08.xlsx - Data Dictionary.csv
│   └── CA - Final_PRA_29194 - 2026-04-08.xlsx - Detail.csv
│   └── CA - Final_PRA_29194 - 2026-04-08.xlsx - Lookup Table.csv
│   └── California_Hospital_Geocodes.csv
│
├── Colorado/
│   └── Colorado_Hospital_Goecodes.csv
│   └── CO - Data_Request_-_Michael_Nolan-_03.30.2026_-_Facility_Occurrences_CY_23-25xlsx.xlsx - Data.csv
│   └── CO-Hospital Data with Geocodes.csv
│
├── Michigan/
│   └── MI - Critical_Incident._SUD_Sentinel_Event_FOIA_Request.1-1-23_to_1-1-25.xlsx - FOIA Request 10.1.22-3.18.26.csv
│
├── Washington/
│   └── WA-downloadable_ae - 2026-04-07.csv
│   └── Washington_Hospital_Geocodes.csv
│
├── CA_EDA.ipynb            # Analysis on California Data
├── CO_EDA.ipynb            # Analysis on Colorado Data
├── Comparisons.ipynb       # Comparison Analysis of all 4 states
├── MI_EDA.ipynb            # Analysis on Michigan Data
├── WA_EDA.ipynb            # Analysis on Washington Data
├── sql_queries.txt         # Queries to extract information from Datasette
├── datasette-env/          # Virtual environment (created during setup)
├── patient_safety.db       # SQLite database (generated)
├── metadata.json           # Datasette configuration
├── requirements.txt
└── README.md
```

---

# Installation

## 1. Clone the repository

```bash
git clone <repository-url>
cd adverse-events-statewide
```

---

## 2. Create a virtual environment

```bash
python3 -m venv datasette-env
```

Activate the environment.

### macOS / Linux

```bash
source datasette-env/bin/activate
```

### Windows

```powershell
datasette-env\Scripts\activate
```

---

## 3. Upgrade pip

```bash
python -m pip install --upgrade pip
```

---

## 4. Install project dependencies

```bash
pip install -r requirements.txt
```

If a `requirements.txt` file is not available, install manually:

```bash
pip install \
datasette \
sqlite-utils \
datasette-cluster-map \
datasette-leaflet \
datasette-vega \
datasette-pretty-json \
datasette-edit-schema \
datasette-configure-fts
```

---

# Build the SQLite Database

This is already set up in this repo as "patient_safety.db". If not found or if you run through any errors then go through these steps, or else skip to Metadata Configuration step.

Import the California dataset:

```bash
python -m sqlite_utils insert patient_safety.db california \
"California/CA-Hospital Data with Geocodes.csv" \
--csv --detect-types
```

Import the Colorado dataset:

```bash
python -m sqlite_utils insert patient_safety.db colorado \
"Colorado/Colorado_Hospital_Goecodes.csv" \
--csv --detect-types
```

Verify the imported tables:

```bash
python -m sqlite_utils tables patient_safety.db
```

Expected output:

```text
california
colorado
```

---

# Metadata Configuration

Create a file named `metadata.json` in the project root. This file has already been set-up in this repo, when cloned, if not found run the code below.

```json
{
  "title": "Public Safety Hospital Explorer",
  "description": "Interactive exploration of state hospital datasets.",
  "plugins": {
    "datasette-cluster-map": {
      "latitude_columns": ["LAT"],
      "longitude_columns": ["LON"]
    }
  }
}
```

---

# Launch Datasette

Start the server:

```bash
python -m datasette patient_safety.db --metadata metadata.json
```

The application will be available at:

```
http://127.0.0.1:8001
```

Open this address in your web browser.

---

# Adding Additional Datasets

To import another CSV into the same database:

```bash
python -m sqlite_utils insert patient_safety.db <table_name> \
"path/to/file.csv" \
--csv --detect-types
```

Example:

```bash
python -m sqlite_utils insert patient_safety.db washington \
"Washington/WA-Hospital-Geocodes.csv" \
--csv --detect-types
```

Each imported CSV becomes its own table in the SQLite database.

---

# Useful Commands

### List all tables

```bash
python -m sqlite_utils tables patient_safety.db
```

### View a table schema

```bash
python -m sqlite_utils schema patient_safety.db california
```

### Launch Datasette

```bash
python -m datasette patient_safety.db --metadata metadata.json
```

### Stop the server

Press:

```text
Ctrl + C
```

### Deactivate the virtual environment

```bash
deactivate
```

---

# requirements.txt

Create a file named `requirements.txt` containing:

```text
datasette
sqlite-utils
datasette-cluster-map
datasette-leaflet
datasette-vega
datasette-pretty-json
datasette-edit-schema
datasette-configure-fts
```

---

# Notes

- Always launch Datasette using:

```bash
python -m datasette
```

instead of

```bash
datasette
```

This ensures that the Datasette installation inside the project's virtual environment is used rather than another Python installation managed by `pyenv`, `conda`, or the system Python.

- The project expects the coordinate columns to be named `LAT` and `LON`. If your CSV files use different names (such as `Latitude` and `Longitude`), update `metadata.json` accordingly.

- The SQLite database (`patient_safety.db`) can be regenerated at any time by deleting it and re-importing the CSV files.
