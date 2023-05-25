.PHONY: shares blob simple management-policies containers diagnostic-settings

shares:
	cd tests && go test -v -timeout 60m -run TestApplyNoError/shares

containers-blob:
	cd tests && go test -v -timeout 60m -run TestApplyNoError/containers-blob

simple:
	cd tests && go test -v -timeout 60m -run TestApplyNoError/simple

management-policies:
	cd tests && go test -v -timeout 60m -run TestApplyNoError/management-policies

queues:
	cd tests && go test -v -timeout 60m -run TestApplyNoError/queues

diagnostic-settings:
	cd tests && go test -v -timeout 60m -run TestApplyNoError/diagnostic-settings

private-endpoint:
	cd tests && go test -v -timeout 60m -run TestApplyNoError/private-endpoint
