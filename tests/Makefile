# Where the gws script is located
GWS_SCRIPT=$(PWD)/../src/gws

# Workspace folder name
WORKSPACE=Workspace
TEST_CLONE_WORKSPACE=$(WORKSPACE)_test_clone
TEST_UPDATE_WORKSPACE=$(WORKSPACE)_test_update

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
	cd $(WORKSPACE)/tools/q; touch testfile; git add testfile; git commit -m message
	cd $(WORKSPACE)/tools; rm -rf peru
	cd $(WORKSPACE)/tools/coursera-dl; touch test; git add test

clean:
	rm -rf $(WORKSPACE) $(TEST_CLONE_WORKSPACE) $(TEST_UPDATE_WORKSPACE)

.PHONY: tests perturbate test_project_gws test_status test_clone test_update test_check test_fetch test_ff clean

tests: test_clone test_update

test_clone:
	rm -rf $(TEST_CLONE_WORKSPACE)
	mkdir -p rf $(TEST_CLONE_WORKSPACE)
	cp test_update_projects.gws $(TEST_CLONE_WORKSPACE)/.projects.gws
	cp test_update_ignore.gws $(TEST_CLONE_WORKSPACE)/.ignore.gws
	cd $(TEST_CLONE_WORKSPACE); $(GWS_SCRIPT) clone ignoring/gws gws2 >/dev/null
	# clone command clones only the named project, and overrides ignore settings
	test -d $(TEST_CLONE_WORKSPACE)/ignoring/gws
	test ! -d $(TEST_CLONE_WORKSPACE)/gws
	test -d $(TEST_CLONE_WORKSPACE)/gws2

test_update:
	rm -rf $(TEST_UPDATE_WORKSPACE)
	mkdir -p rf $(TEST_UPDATE_WORKSPACE)
	cp test_update_projects.gws $(TEST_UPDATE_WORKSPACE)/.projects.gws
	cp test_update_ignore.gws $(TEST_UPDATE_WORKSPACE)/.ignore.gws
	cd $(TEST_UPDATE_WORKSPACE); $(GWS_SCRIPT) update >/dev/null
	# update command clones all projects except ignored ones
	test ! -d $(TEST_UPDATE_WORKSPACE)/ignoring/gws
	test -d $(TEST_UPDATE_WORKSPACE)/gws
	test -d $(TEST_UPDATE_WORKSPACE)/gws2
