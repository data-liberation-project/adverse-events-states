# Adverse Events State by State Data

- What project is that part of? DLP, patient safety etc.
- Background on this data
- What are adverse events? What is the field of "patient safety"?

# Data

- What states of data do we have? What summary overview can we say about each dataset?
- Links to requests on MuckRock
- How are/aren't these data tracked across the country?
- Why are they important?
- Overview of where to find that data and how this project is structured

# Caveats and Limitations

- This is where we give our readers the "here be dragons" warning. What challenges and pitfalls will they likely encounter with the data? How can they solve those?
- What do we know about how different each dataset is for the states we have? Do the conclusions reporters can reach with each dataset vary?
- Any specifics we're concerned about for each dataset?

# Technical documentation

## Setup

Clone this repo:

```bash
git clone https://github.com/data-liberation-project/adverse-events-states.git
cd adverse-events-states
```

Install [pipenv](https://pipenv.pypa.io/), if you don't already have it:

```bash
pip install pipenv
```

> **Don't create your own virtualenv before running pipenv commands.** Pipenv creates and manages its own virtual environment automatically — you don't need `python -m venv venv` first. If a different virtualenv is already active when you run pipenv, pipenv will quietly install into *that* environment instead of its own (it prints a `Courtesy Notice: Pipenv found itself running within a virtual environment...` when this happens — easy to miss). This can leave packages installed in one environment while `datasette serve` runs from another, which shows up as confusing, hard-to-diagnose errors later. If you already have a venv active from something else, either deactivate it first or run `PIPENV_IGNORE_VIRTUALENVS=1 pipenv install`.

`patient_safety.db` isn't tracked in this repo — once every state's data is loaded, it's larger than GitHub's 100MB file size limit. Build it locally instead from the CSVs in `data/processed/`, as shown below.

### macOS / Linux

```bash
# Install the project's dependencies
make install
```

**Verify the plugins installed correctly before moving on:**

```bash
pipenv run datasette plugins
```

This should print a non-empty list including `datasette-vega`, `datasette-cluster-map`, and `datasette-comments` (plus a handful of others). If it prints `[]` instead, the dependencies didn't actually land in the environment `datasette` runs from — re-run the install to force it from the lockfile:

```bash
pipenv install
pipenv run datasette plugins   # confirm it's non-empty now
```

If it's still empty, check that pipenv is pointing at the environment you expect with `pipenv --venv`. See [Troubleshooting](#troubleshooting) below for what happens if you skip this check.

```bash
# Build the database
# This loads each state's CSV from data/processed/ into its own table
# (california, colorado, washington, etc.)
for dir in data/processed/*/; do
  state=$(basename "$dir")
  csv=$(find "$dir" -maxdepth 1 -name "*.csv")
  if [ -n "$csv" ]; then
    table=$(echo "$state" | tr '[:upper:]' '[:lower:]')
    pipenv run sqlite-utils insert patient_safety.db "$table" "$csv" --csv --replace
  fi
done

# Start the server
make run

# The application will be available
http://127.0.0.1:8001
```

### Windows

`make` isn't available by default on Windows, so either install it or run the underlying commands directly.

**Option 1: Install Make**

Install [Make for Windows](https://gnuwin32.sourceforge.net/packages/make.htm), or via a package manager:

```powershell
choco install make
# or
winget install GnuWin32.Make
```

Then install the project's dependencies and start the server the same way as macOS/Linux:

```powershell
make install
```

**Verify the plugins installed correctly before moving on:**

```powershell
pipenv run datasette plugins
```

This should print a non-empty list including `datasette-vega`, `datasette-cluster-map`, and `datasette-comments`. If it prints `[]`, force a reinstall from the lockfile with `pipenv install`, then check again. See [Troubleshooting](#troubleshooting) for details.

```powershell
make run
```

Build the database using the PowerShell commands from Option 2 below (Make for Windows doesn't include the Unix tools the macOS/Linux database-build step relies on).

**Option 2: Run the commands directly (no Make required)**

```powershell
# Install the project's dependencies
pipenv sync

# Verify the plugins installed correctly
pipenv run datasette plugins
# Should list datasette-vega, datasette-cluster-map, datasette-comments, and others.
# If it prints an empty list, run: pipenv install
# then check again before continuing.

# Build the database
# This loads each state's CSV from data/processed/ into its own table
# (california, colorado, washington, etc.)
Get-ChildItem -Directory data/processed | ForEach-Object {
    $state = $_.Name
    $csv = Get-ChildItem -Path $_.FullName -Filter *.csv | Select-Object -First 1
    if ($csv) {
        $table = $state.ToLower()
        pipenv run sqlite-utils insert patient_safety.db $table $csv.FullName --csv --replace
    }
}

# Start the server
pipenv run datasette serve patient_safety.db --metadata metadata.json --setting sql_time_limit_ms 5000 --setting facet_suggest_time_limit_ms 5000 --setting facet_time_limit_ms 10000

# The application will be available
http://127.0.0.1:8001
```

Open this address in your web browser.
