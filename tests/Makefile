# Where the gws script is located
GWS_SCRIPT=$(PWD)/../src/gws

CLONE_SOURCE=test-repo

# Workspace folder name
WORKSPACE=Workspace
TEST_CLONE_WORKSPACE=$(WORKSPACE)_test_clone
TEST_UPDATE_WORKSPACE=$(WORKSPACE)_test_update

TEST_CHECK_OUTPUT=$(PWD)/tmp.test_check_output
TEST_CHECK_EXPECTED=$(PWD)/test_check.expected.txt
TEST_STATUS_OUTPUT=$(PWD)/tmp.test_status_output
TEST_STATUS_EXPECTED=$(PWD)/test_status.expected.txt

prepare:
	$(MAKE) clean				# Clean existing folder
	git clone https://github.com/StreakyCobra/gws $(CLONE_SOURCE)
	git -C $(CLONE_SOURCE) checkout develop
	git -C $(CLONE_SOURCE) checkout gh-pages
	git -C $(CLONE_SOURCE) checkout master
	$(MAKE) $(WORKSPACE)			# Prepare the workspace
	$(MAKE) $(WORKSPACE)/.project.gws	# Generate .project.gws
	$(MAKE) $(WORKSPACE)/.ignore.gws	# Create an .ignore.gws
	$(MAKE) perturbate			# Apply some perturbations on the code

$(WORKSPACE):
	mkdir -p $(WORKSPACE)/{work,tools,ignoring}
	git clone $(CLONE_SOURCE) $(WORKSPACE)/work/neuraltalk
	git clone $(CLONE_SOURCE) $(WORKSPACE)/work/docker-gitlab
	cd $(WORKSPACE)/work/docker-gitlab; git checkout gh-pages
	git clone $(CLONE_SOURCE) $(WORKSPACE)/tools/q
	cd $(WORKSPACE)/tools/q; git checkout gh-pages
	cd $(WORKSPACE)/tools/q; git remote add myone http://coool
	cd $(WORKSPACE)/tools/q; git remote add upstream testurl
	git clone $(CLONE_SOURCE) $(WORKSPACE)/tools/peru
	git clone $(CLONE_SOURCE) $(WORKSPACE)/tools/coursera-dl
	cd $(WORKSPACE)/tools/coursera-dl; git checkout master
	git init $(WORKSPACE)/tools/emptyyyy
	git init $(WORKSPACE)/tools/another
	cd $(WORKSPACE)/tools/another; \
		git checkout -b aaaaabbbbbcccccdddddeeeeefffffggggghhhhhiiiiiccccc; \
		touch test; git add test; git commit -m message
	git clone $(CLONE_SOURCE) $(WORKSPACE)/ignoring/gws
	git clone $(CLONE_SOURCE) $(WORKSPACE)/work/gws
	cd $(WORKSPACE)/ignoring/gws; git checkout develop
	git init $(WORKSPACE)/prefix/foo
	git init $(WORKSPACE)/prefix/foo-bar

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
	git clone $(CLONE_SOURCE) $(WORKSPACE)/nested-gws
	git clone $(CLONE_SOURCE) $(WORKSPACE)/nested-gws/nested-gws

clean:
	rm -rf $(WORKSPACE) $(TEST_CLONE_WORKSPACE) $(TEST_UPDATE_WORKSPACE) $(CLONE_SOURCE)

.PHONY: tests perturbate test_project_gws test_status test_clone test_update test_check test_fetch test_ff clean

tests: prepare test_check test_clone test_status test_update

test_check:
	cd $(WORKSPACE); $(GWS_SCRIPT) check > $(TEST_CHECK_OUTPUT)
	git diff --no-index $(TEST_CHECK_EXPECTED) $(TEST_CHECK_OUTPUT)

test_check_expectation:
	cd $(WORKSPACE); $(GWS_SCRIPT) check > $(TEST_CHECK_EXPECTED)

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

test_status:
	rm -f $(TEST_STATUS_OUTPUT)
	cd $(WORKSPACE) && $(GWS_SCRIPT) | cat >> $(TEST_STATUS_OUTPUT)
	cd $(WORKSPACE) && $(GWS_SCRIPT) status | cat >> $(TEST_STATUS_OUTPUT)
	cd $(WORKSPACE) && $(GWS_SCRIPT) status tools/q | cat >> $(TEST_STATUS_OUTPUT)
	cd $(WORKSPACE) && $(GWS_SCRIPT) status work/neuraltalk | cat >> $(TEST_STATUS_OUTPUT)
	cd $(WORKSPACE) && $(GWS_SCRIPT) --only-changes | cat >> $(TEST_STATUS_OUTPUT)
	cd $(WORKSPACE) && $(GWS_SCRIPT) --only-changes tools/q | cat >> $(TEST_STATUS_OUTPUT)
	cd $(WORKSPACE) && $(GWS_SCRIPT) --only-changes work/gws | cat >> $(TEST_STATUS_OUTPUT)
	cd $(WORKSPACE) && $(GWS_SCRIPT) status --only-changes | cat >> $(TEST_STATUS_OUTPUT)
	cd $(WORKSPACE) && $(GWS_SCRIPT) status --only-changes tools/q | cat >> $(TEST_STATUS_OUTPUT)
	cd $(WORKSPACE) && $(GWS_SCRIPT) status --only-changes work/gws | cat >> $(TEST_STATUS_OUTPUT)
	git diff --no-index $(TEST_STATUS_EXPECTED) $(TEST_STATUS_OUTPUT)

test_status_expectation:
	rm -f $(TEST_STATUS_EXPECTED)
	cd $(WORKSPACE) && $(GWS_SCRIPT) | cat >> $(TEST_STATUS_EXPECTED)
	cd $(WORKSPACE) && $(GWS_SCRIPT) status | cat >> $(TEST_STATUS_EXPECTED)
	cd $(WORKSPACE) && $(GWS_SCRIPT) status tools/q | cat >> $(TEST_STATUS_EXPECTED)
	cd $(WORKSPACE) && $(GWS_SCRIPT) status work/neuraltalk | cat >> $(TEST_STATUS_EXPECTED)
	cd $(WORKSPACE) && $(GWS_SCRIPT) --only-changes | cat >> $(TEST_STATUS_EXPECTED)
	cd $(WORKSPACE) && $(GWS_SCRIPT) --only-changes tools/q | cat >> $(TEST_STATUS_EXPECTED)
	cd $(WORKSPACE) && $(GWS_SCRIPT) --only-changes work/gws | cat >> $(TEST_STATUS_EXPECTED)
	cd $(WORKSPACE) && $(GWS_SCRIPT) status --only-changes | cat >> $(TEST_STATUS_EXPECTED)
	cd $(WORKSPACE) && $(GWS_SCRIPT) status --only-changes tools/q | cat >> $(TEST_STATUS_EXPECTED)
	cd $(WORKSPACE) && $(GWS_SCRIPT) status --only-changes work/gws | cat >> $(TEST_STATUS_EXPECTED)

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
	test ! -d $(TEST_UPDATE_WORKSPACE)/gws3
	test -d $(TEST_UPDATE_WORKSPACE)/gws4
