package main

import (
	"testing"

	"github.com/aztfmods/module-azurerm-sa/shared"
	"github.com/gruntwork-io/terratest/modules/terraform"
)

func TestApplyNoError(t *testing.T) {
	t.Parallel()

	tests := []shared.TestCase{
		{Name: "simple", Path: "../examples/simple"},
		{Name: "shares", Path: "../examples/shares"},
		{Name: "containers-blob", Path: "../examples/containers-blob"},
		{Name: "management-policies", Path: "../examples/management-policies"},
		{Name: "diagnostic-settings", Path: "../examples/diagnostic-settings"},
		{Name: "queues", Path: "../examples/queues"},
	}

	for _, test := range tests {
		t.Run(test.Name, func(t *testing.T) {
			terraformOptions := shared.GetTerraformOptions(test.Path)

			terraform.WithDefaultRetryableErrors(t, &terraform.Options{})

			defer shared.Cleanup(t, terraformOptions)
			terraform.InitAndApply(t, terraformOptions)
		})
	}
}
