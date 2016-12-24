# Where the gws script is located
GWS_SCRIPT=$(PWD)/../src/gws

# Workspace folder name
WORKSPACE=Workspace

prepare:
	$(MAKE) clean				# Clean existing folder
	$(MAKE) $(WORKSPACE)			# Prepare the workspace
	$(MAKE) $(WORKSPACE)/.project.gws	# Generate .project.gws
	$(MAKE) $(WORKSPACE)/.ignore.gws	# Create an .ignore.gws
	$(MAKE) perturbate			# Apply some perturbations on the code

$(WORKSPACE):
	mkdir -p $(WORKSPACE)/{work,tools,ignoring}
	git clone https://github.com/karpathy/neuraltalk.git $(WORKSPACE)/work/neuraltalk
	git clone https://github.com/sameersbn/docker-gitlab.git $(WORKSPACE)/work/docker-gitlab
	cd $(WORKSPACE)/work/docker-gitlab; git checkout gh-pages
	git clone https://github.com/harelba/q $(WORKSPACE)/tools/q
	cd $(WORKSPACE)/tools/q; git checkout gh-pages
	cd $(WORKSPACE)/tools/q; git remote add myone http://coool
	cd $(WORKSPACE)/tools/q; git remote add upstream testurl
	git clone https://github.com/buildinspace/peru $(WORKSPACE)/tools/peru
	git clone https://github.com/dgorissen/coursera-dl $(WORKSPACE)/tools/coursera-dl
	cd $(WORKSPACE)/tools/coursera-dl; git checkout master
	git init $(WORKSPACE)/tools/emptyyyy
	git init $(WORKSPACE)/tools/another
	cd $(WORKSPACE)/tools/another; \
		git checkout -b aaaaabbbbbcccccdddddeeeeefffffggggghhhhhiiiiiccccc; \
		touch test; git add test; git commit -m message 
	git clone https://github.com/StreakyCobra/gws $(WORKSPACE)/ignoring/gws
	cd $(WORKSPACE)/ignoring/gws; git checkout develop

$(WORKSPACE)/.ignore.gws: $(WORKSPACE)
	echo "^ignoring/" > $@

$(WORKSPACE)/.project.gws: $(WORKSPACE)
	cd $(WORKSPACE); $(GWS_SCRIPT) init

perturbate:
	cd $(WORKSPACE)/work/neuraltalk; touch test
	cd $(WORKSPACE)/work/docker-gitlab; git checkout master; git reset --hard HEAD^
	cd $(WORKSPACE)/tools/q; touch test; git add test; git commit -m message
	cd $(WORKSPACE)/tools; rm -rf peru
	cd $(WORKSPACE)/tools/coursera-dl; touch test; git add test

clean:
	rm -rf $(WORKSPACE)

.PHONY: tests perturbate test_project_gws test_status test_update test_check test_fetch test_ff clean
