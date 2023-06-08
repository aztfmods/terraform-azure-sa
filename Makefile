.PHONY: test

export WORKLOAD
export ENVIRONMENT
export USECASE

#test_extended:

test:
	cd tests && go test -v -timeout 60m -run TestApplyNoError/$(USECASE) ./storage_account_test.go

#test_local:
