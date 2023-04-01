.PHONY: shares blob simple management-policies containers diagnostic-settings

shares:
	cd tests && go test -v -timeout 60m -run TestApplyNoError/shares

blob:
	cd tests && go test -v -timeout 60m -run TestApplyNoError/blob

simple:
	cd tests && go test -v -timeout 60m -run TestApplyNoError/simple

management-policies:
	cd tests && go test -v -timeout 60m -run TestApplyNoError/management-policies

containers:
	cd tests && go test -v -timeout 60m -run TestApplyNoError/containers

diagnostic-settings:
	cd tests && go test -v -timeout 60m -run TestApplyNoError/diagnostic-settings

all: shares blob simple management-policies containers diagnostic-settings
