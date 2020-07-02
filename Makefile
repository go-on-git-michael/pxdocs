SHELL := /bin/bash
BUILDER_IMAGE?=pxdocs:developer
SEARCH_INDEX_IMAGE?=pxdocs-search-index:developer
DEPLOYMENT_IMAGE?=pxdocs-deployment:developer
TOOLING_BRANCH?=master
PORT?=1313
CONTAINER_NAME=pxdocs-develop

.PHONY: image
image:
	docker build -t $(BUILDER_IMAGE) .

.PHONY: search-index-image
search-index-image:
	docker build -t $(SEARCH_INDEX_IMAGE) themes/pxdocs-tooling/deploy/algolia

.PHONY: deployment-image
deployment-image:
	cp -r themes/pxdocs-tooling/deploy/nginx nginx_build_folder
	cp -r public nginx_build_folder/hugo_public
	cat public/redirects.json | docker run --rm -i stedolan/jq -r '.[] | "rewrite ^\(.from)$$ \(.to) permanent;"' > nginx_build_folder/pxdocs-directs.conf
	docker build -t $(DEPLOYMENT_IMAGE) nginx_build_folder
	rm -rf nginx_build_folder

.PHONY: update-theme reset-theme
update-theme:
	git submodule init
	git submodule update
	git submodule foreach git checkout $(TOOLING_BRANCH)
	git submodule foreach git pull origin $(TOOLING_BRANCH)

reset-theme:
	git submodule foreach --recursive git clean -xfd
	git reset --hard
	git submodule foreach --recursive git reset --hard
	git submodule update --init --recursive

.PHONY: develop
develop: image
	docker run --rm \
		$(DOCKER_EXTRA_ARGS) \
		--name $(CONTAINER_NAME) \
		-e VERSIONS_ALL \
		-e VERSIONS_CURRENT \
		-e VERSIONS_BASE_URL \
		-e ALGOLIA_APP_ID \
		-e ALGOLIA_API_KEY \
		-e ALGOLIA_INDEX_NAME \
		-e TRAVIS_BRANCH \
		-e PRODUCT_NAME \
		-p $(PORT):1313 \
		-v "$(PWD):/pxdocs" \
		$(BUILDER_IMAGE) server --bind=0.0.0.0 --disableFastRender

.PHONY: publish-docker
publish-docker:
	source ./export-product-url.sh && docker run --rm \
		--name pxdocs-publish \
		-e VERSIONS_ALL \
		-e VERSIONS_CURRENT \
		-e VERSIONS_BASE_URL \
		-e ALGOLIA_APP_ID \
		-e ALGOLIA_API_KEY \
		-e ALGOLIA_INDEX_NAME \
		-e TRAVIS_BRANCH \
		-e PRODUCT_URL \
		-e PRODUCT_NAME \
		-v "$(PWD):/pxdocs" \
		$(BUILDER_IMAGE) -v --debug --gc --ignoreCache --cleanDestinationDir

.PHONY: search-index-docker
search-index-docker:
	docker run --rm \
		--name pxdocs-search-index \
		-v "$(PWD)/public/algolia.json:/app/indexer/public/algolia.json" \
		-e ALGOLIA_APP_ID \
		-e ALGOLIA_API_KEY \
		-e ALGOLIA_ADMIN_KEY \
		-e ALGOLIA_INDEX_NAME \
		-e ALGOLIA_INDEX_FILE=public/algolia.json \
		-e PRODUCT_NAME \
		$(SEARCH_INDEX_IMAGE)

.PHONY: start-deployment-container
start-deployment-container:
	docker run -d \
		--name pxdocs-deployment \
		$(DEPLOYMENT_IMAGE)

.PHONY: stop-deployment-container
stop-deployment-container:
	docker rm -f pxdocs-deployment

.PHONY: check-links
check-links:
	docker run --rm \
		--link pxdocs-deployment:pxdocs-deployment \
		linkchecker/linkchecker http://pxdocs-deployment --check-extern --ignore-url=https?:\/\/[www]*[\.]*[support]*\.rackspace\.com[\/a-z\-]* --ignore-url=https?:\/\/[www]*[\.]*\.youtube\.com[\/a-zA-Z0-9\-\?\=\_\&]*

.PHONY: publish
publish: image publish-docker

.PHONY: search-index
search-index: image search-index-image publish-docker search-index-docker
