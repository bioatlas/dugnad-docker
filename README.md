# Dockerized Dugnad

[![AGPLv3 License](http://img.shields.io/badge/license-AGPLv3-blue.svg)](https://github.com/bioatlas/dugnad-docker/blob/master/LICENSE)

This repo contains materials to build a system with Dugnad using Docker. 

## Usage

Use the Makefile, for example:

		make build
		make debug

## Configuration

To launch dugnad with a specific PDF and a specific language.... you need to configure 

- your specific language translation files
- two config files for the project and the PDF file to use
- initial generation of deep zoom images

### Translate messages

For example, add a directory like `lang/sv_SE/LC_MESSAGES` where `sv_SE` is the iso lang code and underscore and the iso country code. Translated messages then go in the `messages.po` file in that dir. Update the `dugnad-Makefile` to include a command in the `messages` target for the specific language.

### config.yaml

Add entries for the specific language in `config.yaml` with the first one being the default language used, for example:

		title: dugnad
		subheading: annotering & transkribering
		static: '/static'
		lookup:
		  nve: { table: waterbody, key: name }
		links: []
		languages:
		  - ['sv_SE', 'Svenska']
		  - ['nb_NO', 'Norsk']
		oauth: {}

### Using a specific PDF

Let's say your project is called "plan" and you have a plan.pdf. 

You need a project config file for your project, such as the `plan.yaml` file. Customize it according to your needs.

Then add your PDF to `data/plan.pdf` and after launching dugnad make sure this command runs once:

		docker exec -it dugnad \
			bash -c 'scripts/pdf2dzi.sh /code/data/plan.pdf /code/static/plan'


It uses the vips tool with the poppler PDF library to generate the necessary deep zoom image resources for the PDF. These files need to be present when using the dugnad web app.


