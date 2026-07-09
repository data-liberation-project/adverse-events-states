DB = patient_safety.db
METADATA = metadata.json

install:
	pipenv sync

install-dev:
	pipenv sync --dev

run: $(DB) $(METADATA)
	pipenv run datasette serve $(DB) \
		--metadata $(METADATA) \
		--setting sql_time_limit_ms 5000 \
		--setting facet_suggest_time_limit_ms 5000 \
		--setting facet_time_limit_ms 10000

notebook:
	pipenv run jupyter notebook

.PHONY: install install-dev run notebook
