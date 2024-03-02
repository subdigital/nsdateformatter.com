build-image:
	docker build -t nsdateformatter .

run-docker:
	docker run -p 8080:8080 nsdateformatter

sam-build:
	sam build --template deploy/sam-template.yml

sam-deploy:
	sam deploy --template deploy/sam-template.yml --config-file samconfig.toml

deploy: build-image sam-build sam-deploy

