# Adverse Events State by State Data

- What adverse events are 
- How they are/aren't tracked across the country
- Why they're important, with some examples from other investigations or research 


## Data

- Links to requests on MuckRock 
- List other states we've filed to  
- Summary of t


## Caveats and limitations 

- What we know about how different each dataset is 
- Any specifics we're concerned about for each dataset 


## Technical documentation 

### Running Datasette locally 

Start the server:

```bash
python -m datasette patient_safety.db --metadata metadata.json
```

The application will be available at:

```
http://127.0.0.1:8001
```

Open this address in your web browser.

