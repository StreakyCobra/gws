GWS_SCRIPT=$(PWD)/../src/gws
WORKSPACE=Workspace

build: $(WORKSPACE)/.project.gws

$(WORKSPACE):
	mkdir -p $(WORKSPACE)/{work,tools}
	git clone https://github.com/karpathy/neuraltalk.git $(WORKSPACE)/work/neuraltalk
	git clone https://github.com/sameersbn/docker-gitlab.git $(WORKSPACE)/work/docker-gitlab
	git clone https://github.com/harelba/q $(WORKSPACE)/tools/q
	git clone https://github.com/buildinspace/peru $(WORKSPACE)/tools/peru
	git clone https://github.com/dgorissen/coursera-dl $(WORKSPACE)/tools/coursera-dl

$(WORKSPACE)/.project.gws: $(WORKSPACE)
	(cd $(WORKSPACE); $(GWS_SCRIPT) init)

clean:
	rm -rf $(WORKSPACE)

.PHONY: build clean
