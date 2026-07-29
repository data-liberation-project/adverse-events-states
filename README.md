# Adverse Events State by State Data

- What project is that part of? DLP, patient safety etc.
- Background on this data
- What are adverse events? What is the field of “patient safety”?

# Data

- What states of data do we have? What summary overview can we say about each dataset?
- Links to requests on MuckRock
- How are/aren't these data tracked across the country?
- Why are they important?
- Overview of where to find that data and how this project is structured

# Caveats and Limitations

- This is where we give our readers the “here by dragons” warning. What challenges and pitfalls will they likely encounter with the data? How can they solve those?
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

Install the project's dependencies, finish the set up and run it:

### macOS / Linux

```bash
# Install the project's dependencies
make install

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

Then use the same commands as macOS/Linux:

```powershell
make install
make run
```

**Option 2: Run the commands directly (no Make required)**

```powershell
# Install the project's dependencies
pipenv sync

# Start the server
pipenv run datasette serve patient_safety.db --metadata metadata.json --setting sql_time_limit_ms 5000 --setting facet_suggest_time_limit_ms 5000 --setting facet_time_limit_ms 10000

# The application will be available
http://127.0.0.1:8001
```

Open this address in your web browser.
